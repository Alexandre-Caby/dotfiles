#!/usr/bin/env python3
"""Capture harness. Renders a local HTML file (or URL) through chromium and
writes the reviewer's screenshot packet. Settled passes wait for fonts and
1500ms so entrances finish; the anim pass deliberately does not.

The reviewer judges pictures, not code: the hero and each fold as its own
crop at legible scale, never one full-page thumbnail, which hides exactly
the failures that matter behind a superficially similar section order."""
import argparse, json, os, pathlib, sys
os.environ.setdefault("PLAYWRIGHT_BROWSERS_PATH", "/opt/pw-browsers")
from playwright.sync_api import sync_playwright

VIEWPORTS = {"desktop": dict(width=1440, height=900, dsf=1),
             "mobile":  dict(width=390,  height=844, dsf=2)}

def target_url(html):
    return html if html.startswith(("http://", "https://", "file://")) \
        else pathlib.Path(html).resolve().as_uri()

def settle(page):
    page.wait_for_load_state("networkidle")
    try: page.evaluate("document.fonts.ready")
    except Exception: pass
    page.wait_for_timeout(1500)

def folds(page, vp, out, name, files, cap=14):
    total = page.evaluate("document.documentElement.scrollHeight")
    step = int(vp["height"] * 0.9)
    y, i = 0, 0
    while y < total and i < cap:
        page.evaluate(f"window.scrollTo(0, {y})"); page.wait_for_timeout(600)
        f = out / f"{name}-fold-{i:02d}.png"
        page.screenshot(path=str(f)); files.append(f.name)
        y += step; i += 1

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--html", required=True); ap.add_argument("--out", required=True)
    ap.add_argument("--hero-only", action="store_true")
    ap.add_argument("--hover", default=None)
    ap.add_argument("--width", type=int, default=None,
                    help="override desktop width (e.g. 600 for email)")
    a = ap.parse_args()
    if a.width: VIEWPORTS["desktop"]["width"] = a.width
    url = target_url(a.html); out = pathlib.Path(a.out); out.mkdir(parents=True, exist_ok=True)
    files, errors = [], []
    with sync_playwright() as p:
        browser = p.chromium.launch()
        for name, vp in VIEWPORTS.items():
            ctx = browser.new_context(viewport={"width": vp["width"], "height": vp["height"]},
                                      device_scale_factor=vp["dsf"],
                                      is_mobile=(name == "mobile"))
            page = ctx.new_page()
            page.on("pageerror", lambda e: errors.append(str(e)))
            page.on("console", lambda m: errors.append(m.text) if m.type == "error" else None)
            page.goto(url); settle(page)
            f = out / f"{name}-hero.png"; page.screenshot(path=str(f)); files.append(f.name)
            if not a.hero_only:
                f = out / f"{name}-full.png"
                page.screenshot(path=str(f), full_page=True); files.append(f.name)
                folds(page, vp, out, name, files)
            if a.hover and name == "desktop" and not a.hero_only:
                try:
                    el = page.locator(a.hover).first
                    el.scroll_into_view_if_needed(); el.hover(); page.wait_for_timeout(400)
                    box = el.bounding_box()
                    clip = {"x": max(box["x"]-40, 0), "y": max(box["y"]-40, 0),
                            "width": box["width"]+80, "height": box["height"]+80}
                    f = out / "desktop-hover.png"
                    page.screenshot(path=str(f), clip=clip); files.append(f.name)
                except Exception as e: errors.append(f"hover: {e}")
            ctx.close()
        if not a.hero_only:
            ctx = browser.new_context(viewport={"width": VIEWPORTS["desktop"]["width"], "height": 900})
            page = ctx.new_page(); page.goto(url, wait_until="load")
            for ms in (250, 900):
                page.wait_for_timeout(ms if ms == 250 else 650)
                f = out / f"desktop-anim-{ms}.png"; page.screenshot(path=str(f)); files.append(f.name)
            ctx.close()
            ctx = browser.new_context(viewport={"width": VIEWPORTS["desktop"]["width"], "height": 900},
                                      reduced_motion="reduce")
            page = ctx.new_page(); page.goto(url); settle(page)
            f = out / "desktop-rm.png"; page.screenshot(path=str(f)); files.append(f.name)
            rm_height = page.evaluate("document.documentElement.scrollHeight")
            ctx.close()
        browser.close()
    meta = {"url": url, "files": files, "console_errors": errors[:20]}
    if not a.hero_only:
        meta["reduced_motion_height"] = rm_height
    (out / "manifest.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps({"out": str(out), "count": len(files), "errors": len(errors)}))

if __name__ == "__main__": sys.exit(main())
