# Reference — The Craft Floor

The universal knowledge layer: what is true regardless of medium. The finish
reviewer reads this file too — everything here is judged on the rendered
screenshots, not on intent.

## The floor

Below this line the work is broken regardless of how it looks. Verify against
**computed** values, not intent.

| Dimension | Floor |
|---|---|
| **Contrast** | Body and placeholder text ≥ **4.5:1**. Large text (≥24px, or ≥18.7px bold) ≥ **3:1**. Controls, icons, focus indicators ≥ **3:1**. Text over imagery is measured against the *lightest pixel behind it*, not the average. |
| **Secondary text on a colored surface** | Tint it from that surface's hue or from the foreground. **Never gray on color.** |
| **Depth** | A shadow has an **offset and a soft blur**. A zero-offset colored halo is decoration, not depth. |
| **Elevation** | Declared **once** — border *or* shadow. A 1px border under a wide soft shadow is the "ghost card". |
| **Spacing** | Tight within groups, generous between them. **More space above a heading than below it.** |
| **Measure** | Body copy **65–75ch**. Tables and data can exceed this. |
| **Type floor** | Body **16px** minimum on web and mobile (iOS Safari force-zooms focused inputs below 16px). 14px only for genuinely secondary text. |
| **Display ceiling** | **6rem** max, tracking floor **−0.04em** (−0.02 to −0.03em usually reads better). |
| **States** | Hover, focus-visible, disabled, loading, error, empty — tested with real content at 0, 1, and 500 items. |
| **Copy** | Every control names its action. Every error names the problem **and** the recovery. |
| **Controls** | Every control is backed by a real resource or handler. A playable-looking control over a nonexistent file is a broken promise. |
| **Coverage** | Every requirement in the brief contract is present, visible, and findable in seconds. |

## The Refuse list

Category defaults — the shapes that appear when nothing was decided.
Overridable only by the brief's own text or a recorded user answer; the
builder's in-code rationale is inadmissible.

**Structure:**

- Same-size cards of icon + heading + text as the page's structure. Cards are
  the lazy container; **nested cards are always wrong**.
- The hero-metric template: giant number, small label, three supporting stats.
- **A kicker or eyebrow above a heading.** Hard ban — no brief earns it back.
- Section numbers (01 / 02 / 03, lone roman numerals) when the sequence
  carries no information.
- A modal for a task needing neither interruption nor protected focus.

**Surface:**

- Gradient text. Emphasis comes from weight or size.
- Glass and blur as decoration rather than as a material with something
  behind it.
- A colored `border-left` above 1px on cards, list items, callouts, alerts.
- Hard offset shadows (`4px 4px 0`) outside an actually neobrutalist world.
- Monospace worn as a costume for "technical".
- Emoji or a Unicode glyph standing in for an icon system.
- Light or dark chosen by category habit. Write one sentence describing who
  uses this, where, under what light, and let it force the answer.

**The atmosphere exemption.** The material-honesty rule (imitation wood,
metal, paper, emboss = machine signature) does **not** ban light and air:
particle fields, haze, glow, vignettes, and weather are authored material for
a screen-native medium. When the brief demands atmosphere, flat empty fields
are the dishonest answer, not the safe one. Full rule: references/imagery.md.

## Spacing

**4-unit base**: 4, 8, 12, 16, 24, 32, 48, 64, 96, 128. A value off the scale
needs a reason.

**Monotony check:** round every spacing value to the nearest 4. One value
covering more than 60% of samples with ≤3 unique values = a uniform grid
pretending to be a composition.

**Squint test:** blur the layout to masses. Evenly distributed masses = no
hierarchy.

## Type

| Context | Ratio | Steps from 16px |
|---|---|---|
| Expressive (posters, heroes, covers) | 1.25 | 16, 20, 25, 31, 39, 49, 61 |
| Standard (apps, documents, email) | 1.2 | 16, 19, 23, 28, 33, 40, 48 |
| Dense (dashboards, tables) | 1.125 | 16, 18, 20, 23, 26, 29, 32 |

Line height moves inversely with measure. Anchors: display 1.05–1.25 ·
subhead 1.25–1.35 · body 1.5–1.7 · caption 1.4–1.5.

Tracking is size-specific: tighten large text toward −0.02em, body near 0,
micro-labels slightly positive. **Light text on dark compensates on all three
axes**: more leading, more tracking, one weight step up.

**The monoculture** — faces that appear when no decision was made:

> Inter · Roboto · Open Sans · Lato · Montserrat · Arial · Helvetica · Geist ·
> Mona Sans · Plus Jakarta Sans · Space Grotesk · Space Mono · DM Sans · DM
> Serif · Outfit · Instrument Sans · Instrument Serif · Fraunces · Playfair
> Display · Cormorant · Lora · Crimson · Newsreader · Recoleta · Syne · IBM Plex

Naming one requires a reason no other face could satisfy, and *subject
association is never that reason*. Inter is legitimate for a neutral system
face or when accessibility governs. Serif display faces only when the brief
names one, or the work is genuinely editorial/literary/heritage/luxury and
you can say in one sentence why this serif for this brand.

## Color

Build the palette as **roles**, in OKLCH — perceptual lightness is what makes
these constraints checkable.

| Role | Rule |
|---|---|
| **bg** | Default A: pure white `oklch(1 0 0)`. Default B: pure black/near-black, L 0.04–0.12, chroma 0. Tinted (chroma 0.015–0.05) only for an actual named environment, or when the brand color itself is desaturated. |
| **surface** | bg pulled 10–15% toward ink, same hue family. |
| **ink** | ≥ **7:1** against bg. |
| **muted** | ink pulled 40% toward bg, keeping ink's hue. ≥ **3.5:1** against bg. |
| **primary** | Chroma ≤ **0.23** (≤ **0.18** if L > 0.78 — the fluorescent zone). |
| **accent** | Distinct from primary in hue AND lightness; contrast between them ≥ **1.7**. Text-carrying: chroma ≥ 0.10, or L ≥ 0.85, or L ≤ 0.30. Never a muddy mid-tone (L 0.45–0.72, chroma < 0.10). |

**The mood lives in the brand colors and typography, not in the background.**
Warmth in both the ground and the accent is the clearest generated-design
signature.

**Helmholtz–Kohlrausch:** on any saturated mid-luminance fill (L 0.42–0.78,
chroma ≥ 0.08) use **white** text even when a checker says dark passes.

**Attractor zones** (where generated palettes converge — leave alone):
warm-cream + dusty brown · forest green on cream · violet/indigo on white ·
navy + cream + orange accent.

**Strategies** — pick one, don't dribble accents: Restrained (neutrals + one
accent; Operate/Read) · Committed (one saturated color carrying 30–60%;
Persuade) · Full palette (3–4 roles; systems/editorial) · Drenched (the
surface is the color; Experience). One accent, one theme, locked for the
whole surface.

## Shape

One radius scale per surface: all-sharp, all-soft (cards 12–16px), or pill
(999px, small controls only). Mixed systems need a stated rule applied
everywhere. Never a thick accent border on a rounded corner. Never a card in
a card.

## The Tell list

Named fingerprints of generated output. Searchable in your own work.

**Structural:** kicker/eyebrow (uppercase tracked micro-label) above a
heading · 01/02/03 numbering · three same-size icon-heading-sentence cards ·
left-headline/right-explainer as default section header · >2 consecutive
alternating splits · same layout family reused down the page (8 sections need
≥4 structural ideas) · bento grid with an empty cell.

**Copy:** em dashes in shipped design copy (count: zero; scope: visible
strings, not instructional prose) · decorative middle dots · mock-humble
craftsman voice ("Quietly in use at", "Field notes") · fake photo credits ·
invented precision (92%, 4.1×, 48k) · fake scarcity · aphoristic fragment
cadence.

**Surface:** violet-blue gradient on white · cream + dusty brown · gradient
text · zero-offset glow · radial spotlight on dark · uniform radius on
everything · `0 4px 6px rgba(0,0,0,0.1)` · decorative pulsing dots (zero by
default) · marquee (≤1, usually 0) · grain on a scrolling container ·
shape-assembled illustration · div-built fake screenshots.

**Assets:** lorem ipsum in delivered work · hand-rolled icon paths (one real
icon family, one stroke width) · a page with no images called "minimal" ·
**any pixel of a STYLE-DIRECTION reference** (see references/brief-contract.md
— this is contract-grade, above all craft findings).

**The second-order trap:** replacing the generic default with your *own*
recurring default (always warm neutrals, always mono micro-labels) is the
same failure. Rotate display faces and palette families across projects.
Exception: multiple outputs for the *same* product share one system.

## Copy is design

The headline test: could this line belong to a competitor? If yes, rewrite.
Section default: headline ≤8 words, support ≤25 words, one visual or one
action. Past five list items, a plain hairline `<ul>` is the worst option.
One voice register per surface.

**Self-audit before submitting to review:** re-read every visible string.
Flag broken phrasing, unclear referents, cute-but-wrong wordplay,
mock-profound micro-copy. When a string's meaning is uncertain, replace it
with a plain functional sentence. Quotes: ≤3 lines, name AND role, real
typographic quotes or none.

**Mood demands need visual carriers.** A brief's thematic words (sinister,
luxurious, collapsing) map to named visual devices in the brief contract's
mood map. Copy asserting what design refutes is a SAID-NOT-SHOWN finding.

**Foreign glyphs:** decorative non-English text ships with a gloss (glyph →
meaning → why on this element) in the brief contract. Random glyph-as-garnish
is exoticism, and any literate viewer screenshots it.

## Cognitive load

Working memory tops out around **4 items** (Cowan, 2001). One primary button
plus one or two secondary · ≤5 top-level nav items · ≤4 sibling choices at
any decision point · ≤4 items per visual group. Extraneous load is pure
waste: eliminate ruthlessly.

## Severity

| | Meaning | Action |
|---|---|---|
| **P0** | Prevents the task, or breaches the contract | Fix now |
| **P1** | Significant confusion or a demand missed | Fix before delivering |
| **P2** | Annoyance with a workaround | Next pass |
| **P3** | Polish | If time permits |

Tie-breaker: would a user contact support about this? Then ≥ P1.

## Restraint

Complexity budget: high (marketing, posters, events — take a position) ·
medium (product screens, editorial) · low (forms, admin, transactional —
beauty from precision). The decoration test: if removing it loses the
audience nothing, remove it. Quiet ≠ generic: reducing intensity means
saturation 70–85%, weights down one step, hierarchy from weight and space —
not stripping the point of view.

## Constraints from the user

| Stakes | Response |
|---|---|
| Low — a preference you'd have made differently | Do it, executed well. |
| Medium — weakens the design | Do it, then name the cost in one line and offer the adjustment. |
| High — breaks the design (fails contrast, decorative type on critical text) | Deliver what was asked AND an alternative, side by side. |

Always deliver what was asked; optionally offer what's better; never refuse,
never silently "fix". And the brief wins — a pinned aesthetic overrides every
default in this file including the ban lists.

## Internationalization, condensed

RTL mirrors layout, reading order, and directional icons; use logical
properties. CJK: 16px Latin ≈ 17–18px CJK, line-height 1.7–1.8, explicit
fallback chains. Expansion budget 30–40% (German, Finnish, Arabic). Dates
unambiguous (`15 Mar 2026` or ISO). Color meanings don't travel (white =
mourning in much of East Asia; red = luck in China, danger in the West).
