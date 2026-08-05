# Reference — Email

Loaded by aesthetic-craft's SKILL.md when the medium applies. The craft floor (references/craft-floor.md) applies on top of everything here.

Email is the one medium where the browser is not on your side. Everything in the core still applies — the Design Read, the dials, the craft floor, the tell pass, the pre-flight — but this file replaces the *web* assumptions underneath them, because you are shipping into roughly forty rendering engines you cannot test from here, half of which are twenty years old. Two rules follow:
1. **Design for the degraded case first.** Images blocked, fonts missing, colors inverted, `<style>` stripped. If the email is good in that state, it is good everywhere; if it is only good at full fidelity, it is broken for a large minority of recipients.
2. **The preview is the design.** Most recipients see a subject line, a preheader, and the top 300 to 500px; mobile list previews show closer to 100px. Whatever the email is for has to survive that size, in two seconds, while the reader triages.

## Mode for email
Set the mode from the core's axis, per email, not per program. The single most common failure is designing a receipt like a campaign.

| Email kind | Mode | Dials | Consequence |
|---|---|---|---|
| Transactional: receipt, confirmation, password reset, alert, shipping | **Operate** | VAR 2–3 / MOT 1 / DEN 5–6 | Near-zero decoration. Scanned, not read. The information *is* the design: amount, date, order number, one link. A hero image on a receipt reads as a phishing attempt. |
| Onboarding, welcome, lifecycle drip | **Persuade**, low intensity | VAR 4–5 / MOT 1 / DEN 4 | One action per email. Warmth from copy and type, not ornament. |
| Newsletter, digest, roundup | **Read** | VAR 4–5 / MOT 1 / DEN 4–5 | Measure, rhythm, and hierarchy carry it. Repeating block structure is a feature here, not a tell. |
| Campaign, launch, promotion | **Persuade** | VAR 6–7 / MOT 1 / DEN 3 | Point of view mandatory. Still one primary action. |

**MOT is capped at 1 or 2 in every email** — CSS transitions and animations do not render in Outlook and are unreliable in Gmail. The only motion available is an animated GIF, which Outlook for Windows freezes on frame one, so frame one has to carry the whole message. Spend the motion budget on type and structure instead.

## The rendering reality
Every number below is a constraint you design *to*, not a bug you work around later.

| Constraint | Number / behavior | Why |
|---|---|---|
| **Body width** | **600px** max, `max-width` plus a fixed `width` attribute. 640–700px is defensible for modern-only audiences. | 600px fits the Outlook desktop reading pane at 1024px without horizontal scroll; everything downstream assumes it. |
| **Outlook for Windows (2007–2019, and the classic desktop client)** | Renders with the **Microsoft Word HTML engine**. No `max-width`, no `background-image`, no `border-radius` (corners render square), no `box-shadow`, no `float` reliably, no `letter-spacing`, no CSS positioning. Ignores `margin` on images. Scales at 120 DPI on many machines, so images set only in CSS come out 25% too large. | Word was never a layout engine. Give Outlook explicit `width` HTML attributes and padding on `<td>`, and it behaves. |
| **New Outlook / Outlook.com** | Chromium-based, much better CSS, but **forces full color inversion in dark mode** with no opt-out that works everywhere. | Your light palette gets algorithmically flipped, including inside images with light backgrounds. |
| **Gmail** | Web supports `<style>` and media queries. The **Gmail app rendering a non-Google account (IMAP/Exchange) strips `<style>` entirely**, so every media query and class silently dies. | Inline styles are the only ones guaranteed to arrive; treat `<style>` as progressive enhancement only. |
| **Gmail clipping** | Message is clipped with a "[Message clipped] View entire message" link above **~102KB** (102,400 bytes) of HTML. | Everything below the cut, including your unsubscribe link and tracking pixel, stops counting. Target **under 80KB** to leave headroom for merge-tag expansion. |
| **Apple Mail (macOS / iOS)** | Best CSS support of the majors. Respects `color-scheme` and `prefers-color-scheme`; applies its own inversion only when you *have not* declared support. | Declaring `color-scheme` is what buys you control here. |
| **Image blocking** | Outlook desktop blocks external images by default; many corporate clients too. Gmail proxies images through `googleusercontent.com`. | A meaningful share of first opens are text-only. **Alt text is not a fallback, it is the layout in that state.** |
| **Retina images** | Export at **2×**, then set the HTML `width` attribute to the **1×** value (1200px file displayed at `width="600"`). | Setting the display size in the attribute, not just CSS, is what makes Outlook agree on high-DPI screens. |
| **Total weight** | Under **102KB HTML**; images compressed, ideally under **1MB total**, individual images under 200KB. | Mobile data and slow corporate proxies; large emails also correlate with spam scoring. |

## Layout law
| Rule | Why |
|---|---|
| **Tables for layout. Not `<div>`, not flexbox, not grid.** Nested `<table>` elements are correct here, unlike nested cards in the core. | The Word engine understands tables and essentially nothing else. This is the one place where 1998 markup is the professional answer. |
| **`role="presentation"` on every layout table.** | Without it, screen readers announce "table with 3 rows, 2 columns" before every block. |
| **`border="0" cellpadding="0" cellspacing="0"` plus `style="border-collapse: collapse;"` on every table.** | Without `border-collapse: collapse`, Outlook adds phantom gaps between cells that show as hairlines through a colored background. |
| **Explicit `width` HTML attributes, not CSS width alone**, on tables, cells, and images. | Outlook ignores `max-width` and mis-scales CSS-only widths at non-96 DPI. |
| **`padding` on `<td>`, never `margin`.** | `margin` is inconsistent to absent across clients; padding on a table cell renders everywhere. |
| **Single column below 480px, and single column as the default above it too.** | Multi-column table cells do not reflow; 3 columns at 600px become 3 unreadable 200px columns on a phone unless explicitly stacked. |
| **Multi-column requires an explicit stacking plan**: `<style>` media queries at 480px with a known-good fallback, or the hybrid/"ghost table" pattern with `display: inline-block` cells wrapped in `<!--[if mso]>` conditional tables. | Media queries do not survive the Gmail app on non-Google accounts; if your 3-column row is unreadable without them, it is broken for those users. |
| **No flexbox or grid without a table fallback.** In practice: no flexbox or grid. | Zero support in the Word engine. |
| **Background images need a VML fallback for Outlook**: `<v:rect>` with `<v:fill type="frame" src="..." color="#hex">` inside `<!--[if gte mso 9]>`. Always set a solid `color` on the fill. | Without VML the background silently does not paint, and white text on a nonexistent background is invisible; the solid color saves it if the image is blocked too. |
| **Rounded corners and shadows will not appear in Outlook.** | Design something still correct as a square, flat rectangle. |

### Bulletproof buttons
A button is a real `<a>` with padding, inside a `<td>` with a background color — not an image, and not a `<button>` (form elements are stripped or non-functional in most clients).

```html
<td align="center" bgcolor="#1F4A3C" style="border-radius:4px;">
  <a href="https://..." target="_blank"
     style="display:inline-block; padding:16px 32px; font-family:Georgia,'Times New Roman',serif;
            font-size:16px; line-height:20px; font-weight:bold; color:#FFFFFF;
            text-decoration:none; border-radius:4px; mso-padding-alt:0;">
    Download your report
  </a>
</td>
```

- **The `bgcolor` on the `<td>` is what makes it survive** — if the `<a>` styles are stripped, the cell is still a colored block with a link in it. **`mso-padding-alt:0` plus a zero-width `<i>` spacer** is the padding fix for Outlook, which ignores padding on inline elements (alternatively a VML `<v:roundrect>`). **Minimum tap size 44 × 44px**, so `padding: 14px 28px` at 16px/20px line-height is the floor. Full width or 200 to 300px wide on mobile. **Image buttons fail twice**: blocked images leave a hole, and the alt text is not clickable-looking. Never an image.
- **One primary button per email.** Secondary actions are text links, visually subordinate — two equal buttons halve the click-through of both.

## Type in email
| Rule | Number | Why |
|---|---|---|
| Body size | **14px minimum, 16px preferred** | Below 14px, iOS Mail and Gmail app auto-scale text and break your sized table cells; 16px reads better at arm's length. |
| Headlines | **22px minimum**, 24–32px typical, 40px ceiling in a 600px column | Below 22px a headline does not separate from body at preview size; above 40px it wraps to three lines on a phone. |
| Line height | Use **px, never unitless**. Body 22–26px at 16px. Headlines 1.15–1.3 expressed as px (28px headline → 34px). | The Word engine miscomputes unitless `line-height`, often collapsing to single spacing. |
| Letter spacing | **Do not rely on it.** | Ignored entirely by Outlook for Windows — if a tracked-out label was carrying your hierarchy, the hierarchy is gone. |
| Measure | **50–65 characters** at 600px | Narrower than the core's 65–75ch, because a 600px column at 16px is naturally around 55ch. Add horizontal `<td>` padding of 24–40px rather than letting text run to the edge. |
| Font stack | **The fallback stack IS the design.** Pick the *fallback* first, then optionally layer a web font. | Web fonts fail in Outlook for Windows, most Gmail contexts, and many Android clients — designing around one means designing around something most recipients will not see. |

**Usable stacks, all of which render natively somewhere real:**

```
Georgia, 'Times New Roman', Times, serif           /* editorial, warm, high x-height */
'Trebuchet MS', Verdana, Geneva, sans-serif        /* humanist, friendly, wide */
'Segoe UI', Tahoma, Geneva, Verdana, sans-serif    /* Windows-native, neutral */
Verdana, Geneva, sans-serif                        /* widest, best at small sizes */
'Courier New', Courier, monospace                  /* only when genuinely technical */
-apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif  /* system-native */
```

Arial and Helvetica are the email equivalent of the core's font monoculture — what appears when nothing was chosen. Georgia, Verdana, and Trebuchet each have real personality and are installed nearly everywhere; choosing one deliberately is most of the typographic character available to you. **Links get an underline** — many clients override link color (iOS turns detected addresses and phone numbers blue on its own), so color alone is not a signal that survives.

## Touch and click targets
- **44 × 44px minimum** for anything tappable, matching the core — easy to miss in email, because footer links and social icons are the most-mistapped elements on the page.
- **≥ 10px gap between adjacent links.** Two footer links on one line with a `|` between them are a fat-finger trap: the recipient meant "Manage preferences" and hit "Unsubscribe". Stack footer links vertically on mobile with 12 to 16px of vertical padding each. **One primary action per email** — if the brief demands three, the email is three emails, or a digest with a clear ranking.

## The inbox: subject line and preheader
The highest-leverage design decisions in the medium, because they gate everything else.

### Subject line
| | Number |
|---|---|
| Target length | **30–50 characters** |
| Visible on iOS Mail, portrait | **~35–40 characters** before truncation |
| Visible in Gmail app | ~35–45 characters, less with a long sender name |
| Visible in Outlook desktop list | ~60 characters |

**Front-load the hook in the first 35 characters** — everything after is a bonus most mobile recipients never see. "Your March report is ready, plus three things we noticed" truncates fine; "We took a look at your account this month and…" truncates to nothing. Sentence case reads as human; Title Case On Every Word and ALL CAPS read as a marketing system, and all caps is also a spam-filter signal. **The subject line test** (from the core's headline test): could this have come from any competitor? "Your monthly update" could; "Why your signup flow lost 40% of users in March" could not.

### Preheader
The gray text after the subject in the list view. **It must be set explicitly** — otherwise the client scrapes the first visible text in the body, which is how "View in browser" ends up as the second line of persuasion. That leak is the single most common visible defect in real-world email. Length: **40–100 characters** — under 40 the client backfills with body text anyway; over 100 it truncates mid-word in most clients.

```html
<div style="display:none; max-height:0; overflow:hidden; mso-hide:all;
            font-size:1px; line-height:1px; color:#FFFFFF; opacity:0;">
  Revenue up 12 percent. One metric needs your attention.
  &#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;
  &#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;&#847;&zwnj;&nbsp;
</div>
```

The padding characters are not decoration: `&#847;` (combining grapheme joiner) and `&zwnj;` (zero-width non-joiner) occupy the scrape buffer without rendering, so the client stops pulling text before it reaches your logo alt text — roughly 10 to 20 repetitions fills the ~140-character buffer most clients use. `mso-hide:all` hides the block in Outlook, which ignores `display:none` in some versions.

**Complement, do not repeat** — the subject earns the open, the preheader tells them what they get for it:

| Subject | Preheader |
|---|---|
| Your workspace is ready | One thing to set up before you invite anyone. |
| March metrics: the good and the bad | Revenue hit a record. So did churn. |
| We made a mistake | What happened, and what we changed on Tuesday. |
| Still interested? | No hard feelings if not, one click to stop these. |

## Dark mode in email
Somewhere between 30% and 50% of opens happen in a dark-mode client, and behavior differs by client in ways you design for rather than detect.

| Client | Behavior |
|---|---|
| **Outlook.com and new Outlook** | **Forced full inversion.** Backgrounds, text, and often image backgrounds flipped algorithmically. No reliable opt-out. |
| **Apple Mail (macOS, iOS)** | Respects `color-scheme` and `prefers-color-scheme`. Applies its own inversion only to emails that do *not* declare support. |
| **Gmail (app and web)** | **Partial inversion.** Flips near-white backgrounds and near-black text, leaves saturated and mid-tone colors alone — producing the classic broken result: your background flips, your logo does not, and the logo disappears. |

Declare support so the clients that honor it stop guessing:

```html
<meta name="color-scheme" content="light dark">
<meta name="supported-color-schemes" content="light dark">
<style>:root { color-scheme: light dark; supported-color-schemes: light dark; }</style>
```

**Design rules that survive inversion:**

- **Pure `#FFFFFF` and pure `#000000` invert hardest** — a pure-white background becomes pure black, and every soft gray divider becomes a harsh light line. Use `#FAFAF7`, `#F6F5F2`, or another near-white, and `#1A1A1A` to `#222222` for text. This is the one place the core's "pure white, `oklch(1 0 0)`" default is overridden, for mechanical reasons.
- **Logos need a stroke or a plate** — a transparent PNG logo in dark ink vanishes on an inverted background. Add a 1 to 2px light stroke in the asset, or sit the logo on a small solid-color rectangle.
- **Mid-saturation brand colors survive better than near-neutrals** — Gmail's partial inversion leaves saturated fills alone, so a colored CTA stays colored while a pale gray button becomes dark gray with dark text. **Test both**: open the same email in light and dark and confirm the logo is visible, the button still has contrast, and no divider has become a glowing line.

## Accessibility in email
Everything in the core's craft floor applies, plus:

- **Alt text on every image, and it is load-bearing** — with images off, alt text is the only content in that region. `alt="Two people shaking hands"` is useless; `alt="Download your March report"` on a hero saying exactly that is correct. Decorative spacers get `alt=""` so they are skipped. **Style the alt text**: put `color`, `font-size`, and `font-family` in the `<img>` inline style so blocked images degrade into readable, on-brand text rather than 12px Times New Roman.
- **Real text over text-in-images, always** — a headline baked into a JPEG is invisible with images blocked, unselectable, untranslatable, unreadable to screen readers, and a low text-to-image ratio raises spam scores.
- **Semantic headings still matter**: `<h1>` for the main message, `<h2>` for section breaks, styled inline (reset `margin` to `0` and set your own padding — client heading defaults vary wildly). **`<html lang="en">`** (or the real language) for the right pronunciation engine.
- **Contrast 4.5:1 for body, 3:1 for large text**, verified against the actual background color of the cell it sits in, and checked again in the dark-mode render. **Descriptive link text** — "Read the March report" beats "click here", which a screen reader user hears out of context in a links list. **Source order equals reading order**: table cells are read in document order regardless of visual position.

## Legal and deliverability craft
Design constraints, not legal footnotes — they occupy real space and are routinely designed badly on purpose.

| Requirement | Rule |
|---|---|
| **Physical postal address** | Required by CAN-SPAM for commercial email, with equivalents under CASL and GDPR-adjacent regimes. In the footer, real text, legible. |
| **Working unsubscribe** | Must work, honored within 10 business days under CAN-SPAM, and **findable**: minimum 12px, contrast ≥ 4.5:1 against the footer background. |
| **One-click unsubscribe header** | Gmail and Yahoo require `List-Unsubscribe` and `List-Unsubscribe-Post` (RFC 8058) for bulk senders. A sending-config item, but flag it if you produce the template. |
| **Plain-text alternative** | Send `multipart/alternative` — it serves plain-text clients and smartwatches, and its absence is itself a spam signal. Write it; do not auto-strip the HTML into link soup. |
| **Spam rate** | Keep complaints under **0.3%**, ideally under 0.1%. A hidden unsubscribe link raises this — the practical argument on top of the legal one. |
| **Authentication** | SPF, DKIM, and DMARC alignment. Not your markup, but the reason a perfect template lands in spam. |

**Formatting that trips filters:** all-caps subject lines, three or more exclamation marks, `$$$`, "ACT NOW" stacked with "FREE" stacked with "LIMITED TIME", an image-only body with almost no live text, URL shorteners (bit.ly and friends are heavily abused and heavily scored), link text that does not match the link target, and red 18px bold text on white.

## The email tell list
On top of the core's universal tells. Every one is a shape that appears when nothing was decided.

| Tell | Why it reads as generated | Instead |
|---|---|---|
| **The Template**: centered logo, full-width hero image, headline, paragraph, button, three-column icon-and-caption feature row, social row, footer | The default output of every drag-and-drop builder on earth, which is exactly why it carries zero information about who sent it | Decide the structure from the message. Most emails need a headline, two paragraphs, and one button. |
| **The purple gradient CTA** (violet to blue, rounded, centered) | The core's violet-on-white attractor, ported into email. Gradients also do not render in Outlook, so it degrades to a flat fallback nobody chose | One solid brand color, chosen, with white text and a stated fallback |
| **"Hi {FirstName}," with a visible merge tag** | Shipping `Hi ,` or `Hi {{first_name}},` to real people. Personalization that fails visibly is worse than none | Set a default value, and test the empty case. If you cannot guarantee the field, drop the greeting entirely. |
| **The all-image email** | One sliced JPEG, no live text. Invisible with images off, unreadable to screen readers, high spam score, unfixable after send | Live text for everything that matters. Images support the text, never carry it. |
| **The handshake hero** | Generic stock photography (handshakes, diverse team laughing at a laptop, glowing dots) signals no one had anything specific to show | A real product screenshot, a real photograph, real data, or no image and a stronger headline |
| **Three social icons nobody clicks** | A template slot. Typical click share is a fraction of a percent, and they leak attention from your CTA | Delete them, or keep the one channel that matters and label it in words |
| **The 8px gray unsubscribe** | Deliberately hidden at 8 to 9px in `#CCCCCC` on white, roughly 1.6:1 contrast — a dark pattern, illegal in several jurisdictions, and it raises spam complaints because people mark as spam instead | 12px minimum, 4.5:1 contrast, plainly worded, next to the address |
| **Emoji in the subject as a substitute for a reason to open** | 🔥🚀✨ prepended to a hookless subject signals bulk mail, and some clients render the glyph as a box | Earn the open with specificity. One emoji is defensible when it carries meaning (a checkmark on a confirmation); three is a carnival. |
| **"Don't miss out!" / "Just checking in!" / "We thought you'd love this"** | Filler copy with no subject and no verb doing real work | Say the thing. "Your trial ends Friday" outperforms every version of "Don't miss out". |
| **A footer taller than the body** | Address, unsubscribe, preferences, social, app-store badges, legal disclaimer, and a second logo, on an email with 40 words | Address, unsubscribe, one line of context. Everything else is a link. |

## Working process
1. **Classify the email and set the mode.** Transactional is Operate. This governs the complexity budget and is the step most often skipped.
2. **Write the subject line and preheader first.** Three to five subject options; pick the most specific and most human. If the pair does not earn an open, the rest of the work does not happen.
3. **Write the body before designing it.** Email is a writing medium wearing a layout: headline, message, CTA label, then structure.
4. **Build the degraded version in your head first** — images off, fonts missing, colors inverted. If that version does not work, the design is wrong, not the client. Then **build with tables, inline styles, explicit widths, padding on cells.**
5. **Run the core critique engine**, plus the email questions: does it read with images off? Is the one action obvious in the first 300px? Would I scan or delete this in my own inbox? Is it under 102KB?
6. **Deliver with the core's Design Rationale**, adding the rendering compromises made and the subject line strategy chosen.

## Generation checklist
*This is the builder's own list. It does not count as verification: the finish reviewer independently judges the rendered screenshots and its verdict is the only pass that matters.* Run after the core pre-flight. Run every box before submitting to the reviewer.

**Structure**
- [ ] Width 600px, set as both a `width` attribute and `max-width`, centered.
- [ ] Tables for layout, all with `role="presentation"`, `border="0" cellpadding="0" cellspacing="0"`, and `border-collapse: collapse`.
- [ ] All CSS inline. `<style>` used only for progressive enhancement, and the email is intact without it.
- [ ] Padding on `<td>`, no layout `margin`. No flexbox, no grid, no `position`.
- [ ] Single column, or an explicit stacking plan that survives the Gmail app on a non-Google account.
- [ ] Any background image has a VML fallback with a solid `color` set.

**Type and targets**
- [ ] Body ≥ 14px (16px preferred). Headlines ≥ 22px. Line height in px, not unitless.
- [ ] No reliance on `letter-spacing`. Font stack works with zero web fonts loaded.
- [ ] Links underlined. Tap targets ≥ 44 × 44px. ≥ 10px between adjacent links.
- [ ] Exactly **one** primary button, built as a real `<a>` with padding in a `bgcolor` cell. **Zero** image buttons.

**Degraded states**
- [ ] Reads correctly with all images blocked. Every image has meaningful alt text, styled inline.
- [ ] Dark mode checked in both directions: logo still visible, button still has contrast, no glowing dividers.
- [ ] `color-scheme` and `supported-color-schemes` declared. No pure `#FFFFFF` background, no pure `#000000` text.
- [ ] HTML under 102KB, ideally under 80KB. Images 2× export, 1× `width` attribute.

**Inbox**
- [ ] Subject 30–50 characters, hook inside the first 35, sentence case.
- [ ] Preheader set explicitly, 40–100 characters, padded with `&#847;&zwnj;&nbsp;` so nothing leaks in behind it.
- [ ] Subject and preheader complement rather than repeat.
- [ ] Emoji in the subject: **0**, unless one carries real meaning.

**Compliance and access**
- [ ] Physical postal address present in real text.
- [ ] Unsubscribe present, ≥ 12px, ≥ 4.5:1 contrast, plainly worded.
- [ ] Plain-text alternative written, not auto-stripped.
- [ ] `<html lang>` set. Semantic `<h1>`/`<h2>` with margins reset. Source order matches reading order.
- [ ] Body contrast ≥ 4.5:1 in light **and** dark render.
- [ ] Every merge tag has a default value, and the empty case was tested.
- [ ] No URL shorteners, no all-caps subject, no image-only body.
