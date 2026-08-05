# Reference — Web

Loaded by aesthetic-craft's SKILL.md for browser-rendered work. The craft floor (references/craft-floor.md) applies on top. If anything moves, also load references/motion.md.

## Layout laws

The rules violated most often and costing the most. Failing any of them means shipping broken work, not a variation.

### The hero
- **It fits the initial viewport.** Headline **≤ 2 lines** on desktop. Supporting text **≤ 20 words** and ≤ 3 lines. The primary action is visible without scrolling.
- **A 4-line hero headline is a font-size error, not a copy-length error.** Default `text-4xl md:text-5xl lg:text-6xl`; go to `text-6xl md:text-7xl` only for a 3-to-5-word headline.
- **Top padding caps at ~6rem** on desktop — more and the page opens with a void.
- **Maximum 4 text elements in the stack**: (optional brand strip) + headline + supporting line + actions (one primary, at most one secondary). Banned inside the hero: a tagline under the buttons, a trust micro-strip, a pricing teaser, feature bullets, an avatar social-proof row. The logo wall goes *under* the hero, never inside it.
- If you can't state the value proposition in 20 words, the value proposition is unclear — the rule isn't too tight.

### Sections
- **A layout family appears at most once per page.** Eight sections need **at least four** distinct structural ideas — three variations on "heading, paragraph, three cards" is one idea used three times.
- **Maximum 2 consecutive alternating image/text splits** (a third is a failure). **Maximum 1 marquee per page**, and usually zero.
- **The split header is not a default** (big headline left, 7-8 columns; small explainer right, 4-5). Stack vertically at a 65ch measure instead, unless the brief specifically wants that tension.
- **Bento grids: N items produce exactly N cells** — an empty cell means the grid was chosen before the content was counted. At least 2–3 cells in a multi-cell grid need real visual variation (an image, a texture, a tinted surface); a grid of typography-on-the-same-background reads as a placeholder.

### Navigation
- One line at desktop. Height capped at **80px**, typically **64–72px**. **≤ 5 top-level items** — more and people stop reading them.
- Name items for their contents — "Progress", "Library" — not vague umbrellas like "Home".

### Grid
- **Use CSS Grid; never hand-calculate widths.** `grid grid-cols-1 md:grid-cols-3 gap-6`, not `w-[calc(33%-1rem)]`.
- Standard breakpoints: **640 / 768 / 1024 / 1280 / 1536**. Three usually suffice. Use `clamp()` for fluid values that don't need a breakpoint. Container `max-w-7xl` or `max-w-[1400px]`, centered.
- **Never `100vh`; always `100dvh`** — `vh` is wrong under the iOS Safari address bar.
- Reading measure **680–720px**. App layouts **1000–1200px**. Cards **~480px**.

## Responsive

A design that only works on desktop is half a design. **Start at 375px and expand** — collapsing from 1440px produces layouts that technically fit and read as afterthoughts.

| | Rule |
|---|---|
| **Touch targets** | **44×44px** minimum on web and iOS; **48×48dp** with ≥8dp gaps on Android. Fingers are not cursors. |
| **Thumb zone** | Primary actions in the bottom half on mobile. The top of the screen is the hardest place to reach. |
| **Collapse, don't shrink** | Horizontal becomes vertical. Reorganize, don't miniaturize. |
| **Type scaling** | 72px headline → 36–42px on mobile. |
| **Spacing compression** | Section 96px → 48–64px. Component 32px → 20–24px. |
| **Hiding** | Decorative elements can hide on mobile. Core content never hides. |
| **Input adaptation** | `@media (pointer: coarse)` → `padding: 12px 20px`; `(pointer: fine)` → `padding: 8px 16px`. |
| **Safe areas** | `env(safe-area-inset-*)`, `max(1rem, env(safe-area-inset-bottom))`, and `viewport-fit=cover` in the viewport meta. |

**Declare the mobile behavior explicitly, in the same component.** "Tailwind will handle it" is not a plan — above VARIANCE 3, asymmetric layouts must be told to collapse to a single column below 768px, or they break. **Check:** works at 375 / 768 / 1200+ · every interactive element ≥44px on touch · reading order still makes sense stacked · no horizontal overflow (an `overflow-x-hidden` wrapper on `<main>` is a safety net, not a fix).

## State design — the invisible 80%

The happy path is maybe 20% of what people actually see; the rest is where web design falls apart. Design **all** of these, not just the one in the screenshot.

| State | What it needs |
|---|---|
| **Empty** | Not a blank void. What will appear here, and the action that starts it. The empty state *is* the onboarding. |
| **Loading** | Skeleton shapes matching the final layout, not a spinner. Load progressively; don't block the page on one slow call. Reserve the space so nothing jumps. |
| **Partial** | Test at **0, 1, and 500 items**. A 3-word title and a 300-word title in the same component. Missing optional fields must not break the layout. |
| **Error** | Specific, with recovery. "Couldn't load your projects — the server is having trouble. Retry in a minute." Inline where it happened, not a full-page takeover. Noticeable, not alarming. |
| **Success** | Answers "did it work?" in under a second. A subtle confirmation. Don't throw confetti at a saved form field. |
| **Disabled** | Visually distinct but still legible, and it explains *why* it's disabled. A mystery gray button is a dead end. |
| **Offline / degraded** | What still works, what doesn't, and say so. Stale data with a "last updated" beats nothing. |

### Forms

Forms are state machines: every input has default, focused, filled, error, valid, disabled.

- **Label above the input. Always.** Never placeholder-as-label — the label vanishes exactly when the user needs it, and it fails for screen readers.
- Helper text present in the markup, error text **below** the field, in plain language: "Email is required", not "Validation error: field_email cannot be null." **Validate on blur, not on keystroke** — don't show an error to someone still typing.
- Visible focus ring on every field: `:focus-visible`, contrast ≥3:1. Subtle success indication on long forms — it reduces anxiety measurably.
- Multi-step: show progress, allow going back, never lose entered data.
- Every input, placeholder, helper, error, and focus ring must pass contrast **against its own section background**, not against white.

### Feedback timing

| Action | Feedback | When |
|---|---|---|
| Click a button | Press state (`scale(0.97)`) | Immediate, <50ms |
| Submit a form | Button loading state, disabled to block double-submit | Immediate, then result |
| Delete something | A confirmation dialog **or** an undo toast — not both | Before, or after |
| Toggle a setting | Visual state change | Immediate |
| Drag and drop | Ghost element, drop-zone highlight, snap | Throughout |
| Background process | Progress or status | Ongoing |

Reserve confirmation dialogs for genuinely destructive, irreversible actions — overusing them trains people to click through, which is worse than not having them. Prefer easy undo.

## Buttons and calls to action

- **Primary CTA labels are 1–3 words** and fit on one line at desktop — a wrapped CTA is a failure; shorten the label or widen the button.
- **One label per intent, per page.** Don't ship "Get in touch", "Let's talk", and "Start a project" on the same page — repetition builds recognition, variety creates doubt.
- **Ghost buttons over photography need a scrim, backdrop, or stroke** — text-on-image contrast is where AA is failed most often.
- Tactile press: `translateY(-1px)` or `scale(0.97)` on `:active`. See references/motion.md.

## Performance is design

Perceived speed *is* perceived quality — a fast, smooth experience feels polished with simpler visuals; a janky one feels broken regardless of looks. **Targets: LCP < 2.5s · INP < 200ms · CLS < 0.1 · 60fps.**

| Choice | Cost | What to do |
|---|---|---|
| Hero background video | Very high | Only when the video *is* the product. Otherwise a still or a CSS surface. |
| Parallax on scroll | Medium | Sparingly, `transform` only. Never move a large image on scroll. |
| High-res images everywhere | Highest typical payload | `srcset` + `sizes`, WebP/AVIF, lazy-load below the fold, **80–85% quality is usually imperceptible**. |
| 3+ font weights | Medium, render-blocking | Two weights. Variable fonts where possible. `font-display: swap`. Subset with `unicode-range`. |
| Complex CSS animation | Low–medium | `transform` and `opacity` only. |
| `backdrop-filter` / blur | Medium, worse on mobile | Never on something that scrolls or animates. Static is fine. Keep under 20px. |
| Canvas / particles | High, continuous | Hero moments only, with a reduced-motion fallback, paused offscreen. |
| Large JS bundles | High, blocks interactivity | Lazy-load charts, maps, editors, 3D. |

Reserve space with `aspect-ratio` so images don't shift the layout. `content-visibility: auto` on long lists. Debounce search at 300ms, throttle scroll handlers at 100ms. **Mobile is the constraint** — a three-year-old phone on a bad connection is the real test environment, and perceived performance is designable: skeletons, progressive images, optimistic updates make things *feel* fast when the network isn't.

## Web accessibility

- **Semantic HTML.** Real `<button>`, `<a>`, `<nav>`, `<main>`, `<h1>`–`<h6>` — a styled `<div>` with an `onClick` is invisible to keyboards and screen readers. **Heading hierarchy in order** (H1 → H2 → H3); style with CSS, don't pick a level for its size.
- **Visible focus on everything interactive.** `:focus-visible` can be beautiful — a ring, a glow, a shift. Removing the outline without replacing it is a bug.
- **Logical tab order.** Custom components need real ARIA roles and keyboard handling; if you're hand-rolling a dropdown with manual focus management, use an accessible primitive library instead.
- **Overlays escape their container.** A tooltip inside `overflow: hidden` gets clipped — use `<dialog>`, the popover API, `position: fixed`, or a portal.
- **Alt text**: informational images get a description; decorative images get `alt=""`. And `prefers-reduced-motion`, `prefers-color-scheme`, `prefers-contrast` all deserve handling.
- Test at **200% browser zoom**. Test with 1000+ item lists and 100+ character names.

## Dark mode

Mandatory for consumer-facing work. Pick **one** token strategy per project — Tailwind `dark:` variants **or** CSS custom properties (`--surface`, `--surface-elevated`, `--text-primary`, `--accent`) — and don't mix them.

- Contrast: AA minimum on body, aim higher on hero copy.
- **Don't desaturate the brand into dark mode** — the accent must stay recognizable; it usually needs a lightness bump, not a saturation cut. Light text on dark needs the three-axis compensation from references/craft-floor.md: more line height, more tracking, one more weight step.
- Pure `#000` and pure `#fff` kill depth in a UI. The exception is a deliberate pure-white or pure-black *page* background chosen as a palette decision.

## Stack conventions

- **Server components by default.** Isolate motion, scroll, and pointer logic into leaf client components rather than marking a whole tree interactive.
- **Check `package.json` before importing anything** — if a dependency isn't there, output the install command before the code that needs it.
- **Fonts via the framework's font loader or a self-hosted `@font-face` with `font-display: swap`** — not a `<link>` to Google Fonts in production. **One icon family, one stroke width, declared globally** — mixing icon sets is instantly visible.
- Reach for an accessible primitive library for dropdowns, dialogs, popovers, and comboboxes rather than rebuilding focus traps by hand. Reach for a motion library only when you need springs, layout animation, exit animation, or gesture values — a hover or a fade is a CSS transition.
- No emoji in production markup or visible UI text unless the brief asks for it.

## Web-specific tells

On top of the universal tell list in references/craft-floor.md:

| Tell | Instead |
|---|---|
| Violet-blue gradient on white | A palette derived from the brief, built as OKLCH roles |
| Identical border radius on every element | One radius posture, applied consistently, or none |
| Three cards in a perfect 3-column grid | Break the grid. Vary sizes. Let something span. |
| Hero → features → testimonials → CTA | A structure that tells *this* product's story |
| Glassmorphism with nothing behind the glass | Depth that serves content — real layering, real overlap |
| `box-shadow: 0 4px 6px rgba(0,0,0,0.1)` | A shadow with a light source and a hue that matches the surface |
| Fake screenshots built from divs | A real screenshot, a generated image, or an honest labelled slot |
| Uppercase micro-label above every heading | Delete it. The heading carries itself. |
| Only the happy path designed | The full state matrix above |
| Animation added because the page felt static | Read references/motion.md and answer the frequency gate |
| Desktop-only, "responsive later" | 375px first |
| Focus outlines removed for looks | Design a focus state you're happy to show |

**When glassmorphism *is* the brief**, do it properly: `backdrop-filter` plus a 1px inner border (`border-white/10`) plus an inset highlight (`inset 0 1px 0 rgba(255,255,255,0.1)`), and a solid-fill fallback under `prefers-reduced-transparency`. Blur alone reads as a smudge.

## Reference points

Directions, not templates. Naming one in your Design Read is a legitimate way to commit.

- **Stripe / Linear / Vercel** — precision, selective color, immaculate spacing. Dev tools, premium SaaS.
- **Apple** — restraint as luxury: massive whitespace, depth through material. Consumer, premium.
- **Airbnb / Figma** — warm, rounded, human. Community and creative tools.
- **Swiss / editorial** — typography-driven, dramatic scale contrast, visible grid. Content, publishing, portfolios.
- **Brutalist / raw** — system faces, hard edges, no radius, high-contrast blocks. Art, editorial, deliberate anti-polish.
- **Terminal / industrial** — mono, hairlines, tabular data, minimal chrome. Developer and infrastructure products.
- **Calm tool** — near-invisible UI, neutral, consistent, fast. Productivity and repeat-use software.

## Register

A register is the visual dialect of an industry — the grammar its audience already reads fluently and expects on sight. Every reference point above is a **product-and-publishing register**: chrome-led, type-led, whitespace-led — the taste distribution this file naturally pulls toward, which is exactly why the register decision has to be explicit. **Naming a register in the Design Read is mandatory.** Answering an art-led brief with a product register is a misread of the same severity as designing an Operate surface as Persuade: the page can obey every rule in this file — contrast, layout laws, checklist — and still be written in the wrong language.

The register missing from the list above, and the one most often needed when it's needed at all:

### Entertainment / game / film marketing
- **The imagery IS the hierarchy.** Walls of bespoke key art, an environment shot per section, character treatment as structure. Type and chrome serve the image, never the reverse — if the strongest element in a section is its heading, the section is failing this register.
- **Density and atmosphere are the product.** Haze, layered light, texture fields, grime, glow, depth. A flat field here reads as unfinished — the *exact opposite* of SaaS, where it reads as confident.
- **Cinematic pacing.** Sections are scenes, scroll is a camera move; a beat with no image is a dead frame, not breathing room.
- **Diegetic motifs.** UI elements borrowed from the fiction's own world: scanlines, HUD brackets, wax seals, terminal readouts, weathered stamps. Chrome that could belong to any website belongs to no world.
- **Video and stills everywhere**, real or honestly slotted (see references/imagery.md). Never a playable-looking control pointing at nothing.

The failure mode this section prevents: a game, film, or music brief answered with immaculate hairline grids, generous whitespace, and a two-column pricing table — it can pass every mechanical check and still read as a bank, and it will be rejected, correctly. When the brief is art-led and no art can be generated, emptiness is not a legal fallback: carry world-density through composition, type used as image, layered light and atmosphere built from the screen's own materials, and honest labelled asset slots where the bespoke art belongs (the atmosphere exemption in references/craft-floor.md makes this explicit: particle fields, haze, and glow are real material for a screen-native medium — the material-honesty ban never mandated a flat void).

## Generation checklist

*This is the builder's own list. It does not count as verification: the finish reviewer independently judges the rendered screenshots and its verdict is the only pass that matters.* Run this after the core checklist in references/craft-floor.md.

- [ ] Hero fits the viewport: headline ≤2 lines, support ≤20 words, CTA visible, top padding ≤6rem, ≤4 stack elements.
- [ ] ≥4 distinct layout families across 8 sections. ≤2 consecutive alternating splits. ≤1 marquee.
- [ ] Bento cells = item count. ≥2 cells carry real visual variation.
- [ ] Nav on one line, ≤80px tall, ≤5 top-level items.
- [ ] `100dvh` not `100vh`. Grid, not width math. No horizontal overflow.
- [ ] Renders correctly at 375 / 768 / 1200+. Touch targets ≥44px. Mobile collapse declared explicitly.
- [ ] Empty, loading, partial, error, success, disabled states all exist. Tested at 0, 1, and 500 items.
- [ ] Labels above inputs. Errors below, in plain language. Validation on blur.
- [ ] Every input, placeholder, helper, and focus ring passes contrast against its own background.
- [ ] Primary CTA ≤3 words, one line, one label per intent.
- [ ] Semantic elements. Heading order unbroken. Visible `:focus-visible` everywhere. Tab order logical.
- [ ] Only `transform` and `opacity` animate. Images have `srcset` and reserved space. Fonts ≤2 weights with `swap`.
- [ ] Dark mode uses one token strategy and keeps the brand accent recognizable.
- [ ] Dependencies verified against `package.json`.
