#!/usr/bin/env python3
"""check_floor.py -- deterministic craft-floor scanner for design artifacts.

Usage:
  python check_floor.py --html artifact.html [--attachments f ...]
                        [--manifest assets/manifest.json] --out findings.json
Exit 0 = no errors (warnings allowed); exit 2 = at least one error.
"""
import argparse, base64, hashlib, html as htmllib, json, os, re, sys
from html.parser import HTMLParser

GRAYS = {"black", "white", "gray", "grey", "silver", "transparent", "currentcolor",
         "none", "inherit", "initial", "unset"}
MONO_FONTS = ["Inter", "Roboto", "Open Sans", "Lato", "Montserrat", "Geist", "Mona Sans",
              "Plus Jakarta", "Space Grotesk", "Space Mono", "DM Sans", "DM Serif", "Outfit",
              "Instrument Sans", "Instrument Serif", "Fraunces", "Playfair", "Cormorant",
              "Lora", "Crimson", "Newsreader", "Recoleta", "Syne", "IBM Plex"]
ROMAN = re.compile(r"^(?:I{1,3}|IV|V|VI{0,3}|IX|X{1,3})$")
EMOJI = re.compile("[\U0001F000-\U0001FAFF☀-➿⬀-⯿️]")


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def is_chromatic(color):
    """True when a CSS color string is clearly non-gray."""
    c = color.strip().lower()
    m = re.match(r"#([0-9a-f]{3}|[0-9a-f]{6})\b", c)
    if m:
        h = m.group(1)
        if len(h) == 3:
            h = "".join(ch * 2 for ch in h)
        r, g, b = (int(h[i:i + 2], 16) for i in (0, 2, 4))
        return max(r, g, b) - min(r, g, b) > 12
    m = re.match(r"rgba?\(\s*([\d.]+)[,\s]+([\d.]+)[,\s]+([\d.]+)", c)
    if m:
        r, g, b = (float(x) for x in m.groups())
        return max(r, g, b) - min(r, g, b) > 12
    m = re.match(r"hsla?\(\s*[\d.]+[,\s]+([\d.]+)%", c)
    if m:
        return float(m.group(1)) > 8
    m = re.match(r"oklch\(\s*[\d.%]+\s+([\d.]+)", c)
    if m:
        return float(m.group(1)) > 0.03
    return bool(re.match(r"[a-z]+$", c)) and c not in GRAYS


def find_color(text):
    m = re.search(r"(#[0-9a-fA-F]{3,8}\b|(?:rgba?|hsla?|oklch)\([^)]*\)|\b[a-zA-Z]+\b)", text)
    return m.group(1) if m else ""


class DomScan(HTMLParser):
    """Collects short-text elements in source order plus heading positions."""
    VOID = {"br", "hr", "img", "input", "meta", "link", "source", "wbr", "col", "base", "area"}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.stack = []          # (tag, classes)
        self.buf = []            # text buffer per stack frame
        self.last_text = None    # (tag, ancestry_tags, ancestry_classes, text)
        self.kickers = []        # candidates fired at heading start
        self.short_texts = []    # every closed element with short direct text
        self.skip = 0

    def handle_starttag(self, tag, attrs):
        if tag in ("h1", "h2", "h3") and self.last_text:
            self.kickers.append(self.last_text)
        if tag in self.VOID:
            return
        if tag in ("script", "style"):
            self.skip += 1
        cls = dict(attrs).get("class", "") or ""
        self.stack.append((tag, set(cls.split())))
        self.buf.append("")

    def handle_data(self, data):
        if self.buf and not self.skip:
            self.buf[-1] += data

    def handle_endtag(self, tag):
        if tag in ("script", "style") and self.skip:
            self.skip -= 1
        while self.stack:
            t, _ = self.stack[-1]
            text = self.buf.pop().strip()
            frame = self.stack.pop()
            if text:
                tags = {f[0] for f in self.stack} | {t}
                classes = set().union(*(f[1] for f in self.stack), frame[1])
                self.last_text = (t, tags, classes, re.sub(r"\s+", " ", text))
                if len(text) <= 40:
                    self.short_texts.append(self.last_text)
            if t == tag:
                break


def css_rules(html):
    css = "".join(re.findall(r"<style[^>]*>(.*?)</style>", html, re.S | re.I))
    css += " " + " ".join(re.findall(r'style="([^"]*)"', html))
    return re.findall(r"([^{}]+)\{([^{}]*)\}", css), css


def visible_text(html):
    t = re.sub(r"<(script|style)\b.*?</\1\s*>", " ", html, flags=re.S | re.I)
    t = re.sub(r"<!--.*?-->", " ", t, flags=re.S)
    t = re.sub(r"<[^>]+>", " ", t)
    return htmllib.unescape(t)


def local_path(ref):
    r = ref.strip()
    if not r or r.startswith(("data:", "http:", "https:", "//", "#", "mailto:", "javascript:", "tel:", "blob:")):
        return None
    return r.split("#")[0].split("?")[0]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--html", required=True)
    ap.add_argument("--attachments", nargs="*", default=[])
    ap.add_argument("--manifest")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    html = open(a.html, encoding="utf-8", errors="replace").read()
    base = os.path.dirname(os.path.abspath(a.html))
    findings = []
    add = lambda rule, sev, ev: findings.append({"rule": rule, "severity": sev, "evidence": ev})

    # --- attachment-reuse -------------------------------------------------
    att = {}
    for f in a.attachments:
        try:
            att[sha256(open(f, "rb").read())] = f
        except OSError as e:
            add("attachment-reuse", "warning", "unreadable attachment %s: %s" % (f, e))
    for m in re.finditer(r"data:image/[a-z+.-]+;base64,([A-Za-z0-9+/=]+)", html):
        try:
            raw = base64.b64decode(m.group(1))
        except Exception:
            continue
        if sha256(raw) in att:
            ctx = html[max(0, m.start() - 80):m.start()]
            where = ("poster attr" if "poster=" in ctx[-30:] else
                     "css url()" if "url(" in ctx[-15:] else
                     "img/src attr" if "src=" in ctx[-30:] else "data: URI")
            add("attachment-reuse", "error",
                "embedded base64 image is byte-identical to attachment %s (%s, offset %d)"
                % (att[sha256(raw)], where, m.start()))
    refs = re.findall(r'<img\b[^>]*?\bsrc="([^"]+)"', html, re.I)
    refs += re.findall(r'<video\b[^>]*?\bposter="([^"]+)"', html, re.I)
    refs += re.findall(r'url\(\s*["\']?([^"\')]+\.(?:png|jpe?g|webp|avif|gif|svg))["\']?\s*\)', html, re.I)
    for ref in refs:
        p = local_path(ref)
        if p and os.path.isfile(os.path.join(base, p)):
            if sha256(open(os.path.join(base, p), "rb").read()) in att:
                add("attachment-reuse", "error",
                    "referenced file %s is byte-identical to attachment %s"
                    % (ref, att[sha256(open(os.path.join(base, p), "rb").read())]))

    # --- dead-resource ----------------------------------------------------
    for tag, attr in (("source", "src"), ("img", "src"), ("video", "src"),
                      ("video", "poster"), ("link", "href"), ("script", "src")):
        for m in re.finditer(r"<%s\b[^>]*?\b%s=\"([^\"]+)\"" % (tag, attr), html, re.I):
            p = local_path(m.group(1))
            if p and not os.path.isfile(os.path.join(base, p)):
                add("dead-resource", "error", "<%s %s=\"%s\"> does not exist on disk" % (tag, attr, m.group(1)))

    # --- manifest-integrity ----------------------------------------------
    if a.manifest:
        mdir = os.path.dirname(os.path.abspath(a.manifest))
        HEAD = lambda b: (b.startswith(b"\x89PNG") or b.startswith(b"\xff\xd8\xff") or
                          (b[:4] == b"RIFF" and b[8:12] == b"WEBP") or b"ftypavif" in b[:32] or
                          b.lstrip()[:1] == b"<")
        try:
            doc = json.load(open(a.manifest, encoding="utf-8"))
        except Exception as e:
            doc, _ = None, add("manifest-integrity", "error", "manifest unreadable: %s" % e)
        paths = [s for s in re.findall(r'"([^"]+\.[A-Za-z0-9]{2,5})"', json.dumps(doc or {}))]
        for p in paths:
            fp = os.path.join(mdir, p)
            if not os.path.isfile(fp):
                add("manifest-integrity", "error", "manifest asset missing: %s" % p)
            elif os.path.getsize(fp) == 0:
                add("manifest-integrity", "error", "manifest asset zero bytes: %s" % p)
            elif not HEAD(open(fp, "rb").read(64)):
                add("manifest-integrity", "error", "manifest asset lacks valid image header: %s" % p)

    # --- DOM parse for kicker / numerals / text rules ---------------------
    dom = DomScan()
    dom.feed(html)
    rules, css = css_rules(html)
    upper_rules = []
    for sel, body in rules:
        ls = re.search(r"letter-spacing\s*:\s*(-?[\d.]+)em", body)
        if re.search(r"text-transform\s*:\s*uppercase", body) and ls and float(ls.group(1)) >= 0.05:
            for s in sel.split(","):
                upper_rules.append((set(re.findall(r"\.([\w-]+)", s)),
                                    set(re.findall(r"(?:^|[\s>+~])([a-zA-Z][a-zA-Z0-9]*)", s))))
    for tag, tags, classes, text in dom.kickers:
        if len(text) >= 40 or not re.search(r"[A-Za-z]", text):
            continue
        allcaps = text == text.upper() and text != text.lower()
        styled = any(rc <= classes and rt <= tags for rc, rt in upper_rules)
        if allcaps or styled:
            add("kicker-above-heading", "error",
                "short %s text \"%s\" immediately precedes a heading" % ("all-caps" if allcaps else "css-uppercased", text))

    nums = [t for _, _, _, t in dom.short_texts if re.match(r"^0\d$", t) or ROMAN.match(t)]
    if nums:
        add("numbered-section-labels", "warning", "decorative sequence labels: %s" % ", ".join(nums[:12]))

    # --- pure-CSS refuse list --------------------------------------------
    if re.search(r"(-webkit-)?background-clip\s*:\s*text", css):
        add("gradient-text", "error", "background-clip: text present")
    for sel, body in rules:
        m = re.search(r"border-(?:left|right)\s*:\s*([\d.]+)px([^;}]*)", body)
        if m and float(m.group(1)) > 1 and "transparent" not in m.group(2) and m.group(2).strip():
            add("side-stripe", "error", "%s{ border-%s }" % (sel.strip()[:40], m.group(0).strip()[:60]))
    for m in re.finditer(r"box-shadow\s*:\s*([^;}\"]+)", css):
        for shadow in re.split(r",(?![^(]*\))", m.group(1)):
            off = re.match(r"\s*(?:inset\s+)?(-?[\d.]+)px\s+(-?[\d.]+)px\s+0(?:px)?(?!\.|\d)", shadow)
            if off and float(off.group(1)) and float(off.group(2)):
                add("hard-offset-shadow", "error", shadow.strip()[:70])
            glow = re.match(r"\s*(?:inset\s+)?0(?:px)?\s+0(?:px)?\s+([\d.]+)px", shadow)
            if glow and float(glow.group(1)) > 0 and is_chromatic(find_color(shadow[glow.end():])):
                add("dark-glow", "error", shadow.strip()[:70])
    if re.search(r"feTurbulence|fractalNoise", html):
        add("fake-grain", "error", "feTurbulence/fractalNoise present")
    for m in re.finditer(r"letter-spacing\s*:\s*(-[\d.]+)em", css):
        if float(m.group(1)) < -0.04:
            add("overtracked", "error", "letter-spacing: %sem" % m.group(1))
    for f in MONO_FONTS:
        if re.search(r"(font-family[^;}]*|@font-face[^}]*)['\"]?%s" % re.escape(f), css, re.I):
            add("monoculture-font", "warning", "%s declared" % f)
    if re.search(r"(?<![a-z-])100vh\b", css):
        add("viewport-unit", "warning", "100vh used (prefer 100dvh)")

    # --- visible-copy rules ----------------------------------------------
    vis = visible_text(html)
    n_em = vis.count("—")
    if n_em:
        add("em-dash-in-copy", "error", "%d em dash(es) in visible copy" % n_em)
    if "lorem ipsum" in vis.lower():
        add("lorem-ipsum", "error", "placeholder \"lorem ipsum\" in visible copy")
    emo = EMOJI.findall(vis)
    if emo:
        add("emoji-in-markup", "warning", "emoji in visible text: %s" % " ".join(sorted(set(emo))[:10]))

    json.dump({"findings": findings}, open(a.out, "w", encoding="utf-8"), indent=2)
    n_err = sum(1 for f in findings if f["severity"] == "error")
    n_warn = len(findings) - n_err
    print("check_floor: %d error(s), %d warning(s) in %s -> %s" % (n_err, n_warn, a.html, a.out))
    sys.exit(2 if n_err else 0)


if __name__ == "__main__":
    main()
