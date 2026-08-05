# Reference — Static & print

Loaded by aesthetic-craft's SKILL.md when the medium applies. The craft floor (references/craft-floor.md) applies on top of everything here.

## What changes when there is no scroll
1. **One frame, one chance.** A poster on a wall gets 1 to 3 seconds; a social graphic is a thumb-stop or a scroll-past. There is no below-the-fold, so hierarchy is not one quality among several — it is the whole job.
2. **You control the eye path, not the browser.** A fixed frame has no default reading order; every placement is a directional instruction, and a composition with no instruction is read in random order.
3. **It is permanent.** No hotfix, no A/B test. A 2mm trim error or a 3:1 headline that needed 4.5:1 ships 5,000 times, which demands more rigor than screen work, not less.

**Design Read addendum for static.** On top of the core's Design Read line, name three more things before generating: the **trim or canvas size and orientation**, the **viewing distance** (arm's length, 6 feet, 60 feet, a 60px thumbnail), and the **substrate** (coated stock, uncoated stock, backlit vinyl, an OLED phone, a laser printer). Those three decide type size, color, and contrast far more than taste does.

## Composition

**Eye path.** Every static piece needs a declared **entry point → flow → anchor**. Entry is the largest, highest-contrast, or most isolated element — if two elements compete for entry, neither wins. Flow is the path onward, built with scale steps, alignment axes, color repetition, and directional cues. Anchor is where the eye stops (the date, the CTA, the logo, the takeaway) — if nothing anchors, the viewer leaves without the actionable fact.

| Structure | Shape | Use for |
|---|---|---|
| **Center-dominant** | One massive focal element, everything orbits | Album covers, single-message posters, high impact |
| **Rule of thirds** | Key elements on the 3×3 intersections | Photography-led work, anything that would otherwise center by default |
| **Diagonal tension** | Primary axis runs corner to corner | Energy, motion, sport, music, youth |
| **Z-pattern** | Top-left → top-right → diagonal → bottom-right | Headline top, CTA bottom, balanced formats |
| **F-pattern** | Top band, then down the left edge | Text-heavy flyers, menus, programmes |
| **Full-bleed type** | Type is the image, cropped by the frame | Editorial covers, protest and gig posters |

Pick one and commit — a composition that is a bit Z-pattern and a bit center-dominant is neither. **The ratio rule.** **The primary element is at least 3 to 4× the size of the secondary tier.** Below roughly 2×, the eye reads two elements as peers and hierarchy collapses. This is the single most violated rule in generated static work, because the safe move is to make everything medium-sized — the failure state. The same applies across the other contrast axes, compounding when combined: scale (3–4×), weight (skip a step, 800 next to 400, not 700 next to 500), density (a tight block against open field), and saturation (one vivid element in a muted palette).

**Whitespace.** Space is an active hierarchy tool: more space around an element reads as more importance, and spacious reads as expensive — luxury work is mostly whitespace with a small mark in it. Use the core's monotony check: if one spacing value dominates, you have a grid, not a composition.

### Safe zones, bleed, and trim
| Format | Bleed | Safe margin from trim | Notes |
|---|---|---|---|
| Any printed piece | **3mm** (0.125in) on all sides | **5mm** from trim for anything that must not be cut | Backgrounds and images extend into bleed; nothing critical does |
| Business card | 3mm | 5mm | On an 85×55mm card that is a real constraint, plan for it early |
| Book cover | 3mm | 5mm, plus spine hinge allowance | Spine width depends on page count and paper bulk; ask for it |
| Saddle-stitched booklet | 3mm | 8mm on inner margins | Creep pushes inner content outward on inner spreads |
| Social feed graphic | none | keep critical content in the **center 80%** | Crops vary by client and change without notice |
| Story / vertical video frame | none | top ~13% and bottom ~22% are covered by platform UI | Never put the CTA in the bottom band |
| Billboard / large format | per vendor spec | 10% of the short edge | Grommets and frames eat the edge |

### The thumbnail test

Render the composition at its worst realistic size and look at it there, not at 100%.

| Piece | Test at |
|---|---|
| Poster | 100px tall, and squinted at full size |
| Album cover | **60px** square (streaming list view) and 300px (player) |
| Book cover | **80px** tall (retail grid) |
| Social feed graphic | 25% zoom, or ~150px wide |
| Logo | see the size ladder below |

If the piece turns to mud, the fix is not sharpening — it is fewer elements, larger type, and higher contrast between the two largest masses.

## Typography as the primary instrument

On a poster, type is often 80% of the design, which makes the display face **the single highest-leverage decision in the whole piece** — higher than the palette, and the one most likely to be made by reflex. The core's font monoculture ban list applies in full and with more force, because a static piece has nothing else to hide behind: a poster set in Montserrat announces it was not designed.

### Hierarchy tiers

Four tiers, each distinguishable at a glance without reading. Tiers 1 and 2 must be separated by the 3–4× ratio rule — two tiers at 1.5× apart is one tier with a rendering inconsistency.

| Tier | Job | Length | Relative size |
|---|---|---|---|
| **1 Primary** | The one thing that must be read | 3–7 words | The 1.0 reference |
| **2 Secondary** | Date, subtitle, tagline, artist | ≤ 12 words | 0.25–0.35 of tier 1 |
| **3 Tertiary** | Venue, credits, price, URL | short lines | 0.08–0.15 of tier 1 |
| **4 Ambient** | Texture, repeated pattern, decorative type | optional | any, but never competing with tier 1 |

### Faces and pairing
- **Maximum 2 typefaces; a third needs a stated reason.** One display plus one workhorse is the standard shape; one face in two weights is often stronger than a clever pair, and never wrong.
- **Contrast, not conflict.** Paired faces should be obviously different in class (grotesque against didone, geometric against humanist) — two faces that are similar but slightly off read as an error. **Share one trait, differ in the rest**: matching x-height, width, or period gives the pair a reason to be together. The display face sets the mood; the text face stays quiet — if both are expressive, they fight and the piece looks amateur.

### Tracking, measure, and setting
The core's rules apply, with these static-specific consequences.

- **A single letter-spacing value is wrong somewhere in the piece.** Tracking is size-dependent: pull display type toward −0.02em, floor at −0.04em (beyond that letters collide, and at poster scale the collision is 4 inches wide), leave body near 0, open micro-labels and small caps slightly positive. **Measure stays 65–75ch** on any body copy the reader has to get through — a flyer with a 110-character line will not be read.
- **Optical kerning, not metric, above roughly 36pt.** Metric kerning is tuned for text sizes; at display size its gaps become visible holes, most obviously around A, V, W, T, Y, quotes, and numerals. Set display lines optically, then fix remaining pairs by eye.
- **Hang the punctuation** — quotes, hyphens, and bullets at the start of a large line push the block visually inward; pull them into the margin so the letterforms define the alignment edge.
- **Center optically, not mathematically.** A centered line ending in a comma or starting with a quote is mathematically centered and visually off — judge the visual mass, not the bounding box. Same for a mark inside a circle: geometric center and optical center differ, and the eye believes the optical one.
- **Light on dark needs all three compensations** from the core (more leading, more tracking, one weight step) — in print even more, because ink spread on uncoated stock thickens the dark ground and thins the knocked-out type.

## Color

**Build in roles, then convert.** Build the palette exactly as the core specifies — **roles first, in OKLCH** (bg, surface, ink, muted, primary, accent), same chroma ceilings, same contrast requirements, white text on any saturated mid-luminance fill — then convert to the output space last. Building in CMYK from the start produces muddy, hedged color, because the space has no perceptual lightness axis to reason with.

### CMYK gamut reality

**Roughly 30% of what your screen shows cannot be printed in four-color process**, and the casualties are exactly the colors generated palettes reach for.

| Screen color | What process printing does to it |
|---|---|
| Neon anything, fluorescent pink, hi-vis yellow-green | Flattens to a dull approximation; needs a spot ink |
| Vivid pure green (`oklch(~0.75 0.24 145)`) | Prints as a tired olive or grass green |
| Electric blue and vivid cyan-purple | Shifts toward navy or violet and loses all the energy |
| Deep saturated orange-red | Loses roughly a step of chroma |
| Anything above chroma ~0.20 at high lightness | Out of gamut, converted by the RIP without asking you |

Design inside the gamut on purpose. If a specific vivid color is the identity, that is the argument for a spot ink, not for hoping.

### Print mechanics
- **Rich black for large areas: C60 M40 Y40 K100** — K100 alone prints as a washed dark grey on any sizeable field. Keep small text at **K100 only**, because four-plate registration on 8pt type produces colored fringes.
- **Total ink coverage stays under ~300%** on coated stock, lower on newsprint (ask the printer) — over that, the sheet does not dry and offsets onto the next one.
- **The paper is part of the palette.** Uncoated stock is warmer and duller and absorbs ink, so everything darkens and spreads; coated stock holds saturation. A cream uncoated sheet turns pure white into an off-white you did not choose — fine only if you chose it.
- **Spot vs process.** Spot (a named premixed ink) gives exact, repeatable, out-of-gamut color: right for a logo, a two-color piece, a brand color that must never drift. Process is right for photography and anything with more than three colors. Metallics and fluorescents are spot only.
- **A screen-designed palette is unproofed — say so in the handoff**, ask for a hard proof on the actual stock for any print run, and never approve brand color from a monitor.

## Material honesty for static work

**Real material, or none.** A flat, honest surface beats a faked physical one every time; faked physicality is the most reliable single mark of machine-made design. The recurring offenders:

- **Filter or CSS "grain"** imitating paper or film — procedural noise sits on top as an even film and reads as a screen effect at any size.
- **A gradient imitating light** — real light has a source, a direction, a falloff, and an agreeing shadow; a three-stop linear gradient has none.
- **Shape-assembled vector imitating illustration** (circles and rounded rectangles arranged into a person, a plant, a city) — reads as a diagram of an illustration.
- **Faked embossing, debossing, letterpress** (a light shadow above, a dark one below) — real letterpress deforms the sheet and pools ink at the impression edge.
- **Foil, gold, metallic gradients** — metal is defined by an environment reflection, not a yellow-to-orange ramp. If the piece needs foil, specify foil as a finish and design the artwork flat, one color, as the foil plate. **Fake torn edges, tape, staples, stitching, wood, concrete** — all the same failure.

**The contradiction rule.** If the brief calls for painted, printed, screen-printed, risograph, textured, collaged, or photographic material and what came out is clean vector, that is a contradiction between brief and artefact, not a stylistic variation — rebuild with the real material (a generated or sourced image, an actual photograph, an actual scan). Patching a vector composition with a noise layer produces a clean piece wearing a costume. The honest alternatives are good: flat solid color, real photography, real generated imagery, real typography at scale, and an actual print finish specified in the handoff.

## Brand identity and logo design

A logo is not a picture — it is a system that has to survive every size and context it will ever appear in.

### The three tests
- **The size ladder.** Design at 240px wide, then check at **16px** (favicon), **32px** (browser tab, small avatar), **60px** (mobile app icon, streaming thumbnail), **240px** (web header), and **480px** (print header, signage). Detail that vanishes at 16px was never doing any work, so remove it at 480px too.
- **The one-color test.** Solid black on white, solid white on black. **A logo that depends on color to be legible is not finished** — it will be faxed, embroidered, engraved, stamped in one ink, cut in vinyl, shown on a black shirt. Design in black and white first; add color as an enhancement, never as structure.
- **The silhouette test.** Fill the mark entirely black and squint: is the outline distinctive among ten competitors' silhouettes? The silhouette is what memory actually stores.

### Logo types
| Type | Example shape | Best for |
|---|---|---|
| **Wordmark** | The name in a distinctive face | Distinctive names, when the name is the brand |
| **Lettermark** | Initials | Long names that get abbreviated anyway |
| **Symbol** | Standalone graphic mark | Established recognition only. A new brand cannot spend a symbol it has not earned |
| **Combination** | Symbol plus wordmark | Most brands. The pieces separate later once recognition exists |
| **Emblem** | Text inside a shape | Heritage, authority, institutions. Scales down badly, so plan a reduced version |

### The system, not the file

A deliverable that is one logo file is incomplete. The set:

- **Primary lockup**; **horizontal lockup** for headers and signatures; **stacked lockup** for square and narrow spaces; **icon only** for favicons and avatars; **one-color black, one-color white, and reversed** versions.
- **Clear space**, defined as a fraction of a named element inside the mark ("clear space equals the cap height of the wordmark", or "the width of the counter in the O") so it scales automatically — a rule in pixels breaks the moment the logo is resized, which is always.
- **Minimum size**, stated separately for print and screen — e.g. 20mm wide in print and 90px on screen for the full lockup, 16px for the icon.
- **Do-not list**: no stretching, re-coloring, drop shadow, outline, rotation, or placement on a busy photo without a solid field. Show the violations, do not just describe them.

### Why generated logos fail

Nearly all fail the same way: **a generic geometric icon set beside a generic sans is a placeholder, not a mark** — an abstract swoosh, a hexagon with a gap, a circle of two arcs, a leaf, an upward arrow, a node graph, a gradient blob, next to a medium-weight geometric sans in slightly loose tracking. Competent, symmetrical, and belonging to no one. The test: **cover the name — does the mark say anything specific about this entity?** If it could sit above a hundred other company names unnoticed, iterate: encode the thing the business actually does, a letterform peculiarity in its name, a historical or geographic fact, a shape from its product. Specificity is what makes it memorable. Related failure: an 8-color brand palette — hold it to 2–3 primaries, 1–2 accents, plus neutrals, each with a stated job, or nobody can apply it consistently.

## Medium-specific

### Posters
- **Size type from the viewing distance, not from the canvas: about 1 inch of cap height per 10 feet** for comfortable reading. 20 feet wants 2 inch caps (roughly 200pt); a hallway at 6 feet wants roughly 0.6 inch (around 60pt). Detail type may be small — it addresses the person who walked closer.
- **One idea** (a poster that says two things says neither), and **design for the environment**: a gallery wall permits subtlety; a telephone pole in daylight competing with twenty other sheets wants maximum tonal contrast between the two largest masses.
- Most posters are portrait, common at A2 (420×594mm), A1 (594×841mm), or 24×36in. Confirm the format before composing.

### Social graphics

Pixel specs drift, ratios do not. **Design to the ratio, export at a generous pixel size**, and verify the current spec at delivery time.

| Placement | Ratio | Typical export |
|---|---|---|
| Square feed post | 1:1 | 1080×1080 |
| Portrait feed post (best feed real estate) | 4:5 | 1080×1350 |
| Story, Reel, vertical video, TikTok | 9:16 | 1080×1920 |
| Landscape link card, X post, Facebook and LinkedIn share | 1.91:1 | 1200×630 |
| Video thumbnail | 16:9 | 1280×720 |

- **Safe zone: critical content stays in the center 80%** of any feed graphic — clients crop feed previews differently and change without notice. On 9:16, treat the top ~13% and bottom ~22% as occupied by platform UI, so the CTA never goes at the bottom.
- **Thumb-stop at thumbnail.** Judge at 25% zoom; if muddy, the fix is fewer elements and bigger type, not more contrast on the same layout. **Minimal text in the image** — the caption is a free text field that already exists; a paragraph belongs there.
- **A series should feel related, not identical.** Lock the palette and type system, vary the composition — five posts with the same layout and different words read as one template.

### Business cards
- **85×55mm (EU) or 3.5×2in (US).** Deviating has a cost at the printer and in every wallet; do it deliberately or not at all.
- **Name, role, one or two contact routes. Stop** — everything extra dilutes the one thing the card is for. **Minimum sizes: no text below 7pt, names at 10–12pt** — below 7pt it is not readable in a bar, where cards are actually read.
- 3mm bleed, 5mm safe margin. On a 55mm-tall card those margins are 18% of the height, so lay them out before designing.
- **The stock is the design.** Weight (350gsm and up reads as serious), finish (uncoated, soft-touch, matte), edge painting, and real letterpress or foil carry more perceived quality than anything inside the artwork.

### Banners and headers
- **Read left to right: mark, then message, then action** — wide-and-short formats have no vertical room, so hierarchy must be horizontal and size-driven.
- **Standard web placements: 728×90, 300×250, 160×600.** Design inside each format — a 160×600 is a different composition from a 728×90, not a squeezed one.
- **Animated banners: the first frame carries the message on its own.** Cap at about 3 frames and 15 seconds; most people see frame one and nothing else. Large physical banners: check grommet positions and pole pockets before placing anything near an edge.

### Mockups
- **Context sells, but the mockup is not the work** — the frame must not out-perform what is inside it. **Curate to 3–5 views**: every state and permutation is documentation, not presentation.
- **One lighting setup and one perspective across the whole set** — mixed light directions on the same board instantly read as assembled from stock.
- The floating-device-in-gradient-space mockup is banned as a default (see the tell list). Put the object somewhere real: a desk, a hand, a wall, a shelf, in real light.

### Album and book covers
- **Both extremes, always**: 60px in a streaming list and full size as a physical object, or 80px in a retail grid and 150mm in a hand. A cover that only works at one end is unfinished.
- **Type usually dominates** — the great covers are mostly typographic; the title is the design. **Genre has a visual language**: know the convention before deciding to follow or break it; breaking it accidentally gets the book shelved wrong.
- **A book cover has three faces**: front, spine, back, plus flaps for a jacket. The spine is what people actually see on a shelf and the one most often left as an afterthought; spine width comes from page count and paper bulk, so get it from the printer before designing.

### Flyers, invitations, menus
- **Hierarchy order: what → when → where → how to respond** — also the order of visual prominence; inverting it is the most common flyer failure.
- **The 5-second read.** Someone should get the key facts without reading a sentence — test by looking away and stating what you retained.
- **Plan for the physical piece**: A5 or half-letter for flyers, double-sided if there is secondary content, folds planned into the composition, not drawn over it.
- **Menus** are read in dim light, often by people over 45: body no smaller than 9pt, generous leading, high contrast, no light grey text on cream. Prices align to the item, not to a distant right rail.

## Static tells

The named fingerprints of generated static work, on top of the universal list in the core.

| Tell | Why it happens | Instead |
|---|---|---|
| **Centered everything** | Centering is the choice you make when you have not made a choice | Rule of thirds, a left axis, deliberate asymmetry |
| **The floating device mockup in gradient space** | The default way to show a screen when no context was chosen | The object in a real place, in real light |
| **Logo top-center, CTA bottom-center, symmetrical between** | The template shape of a generated flyer | An axis, an off-center anchor, a diagonal |
| **A drop shadow behind the headline** | Compensating for type that is not legible against its ground | Fix the ground: a solid field, a crop, a color change |
| **A photo with a flat black overlay at 40%** | Same compensation, larger | A photo with room for type, a real gradient scrim with direction, or move the type |
| **An arbitrary diagonal stripe, blob, or corner swoosh** | Filling a corner that felt empty | Leave it empty. Empty is a composition tool |
| **Unmotivated duotone** | A stylistic effect applied to make a stock photo look intentional | Either the duotone is the identity system, applied everywhere, or it goes |
| **A gradient background** | No palette was decided | Decide the palette. Flat color, real photography, or real texture |
| **Hand-drawn doodle accents** (squiggles, stars, underline swoops) | Borrowed warmth | Warmth from the type, the palette, and the photography |
| **Stock-photo staging** (diverse team laughing at a laptop) | The image slot was filled rather than solved | Real or generated imagery with a point of view, or no image and stronger type |
| **A generic icon next to a generic sans, called a logo** | The modal output of a logo prompt | The specificity test above |
| **Every element the same size** | Nobody decided what mattered | The 3–4× ratio rule |
| **Uniform spacing across the whole frame** | A grid used as a substitute for composition | Tight within groups, open between them |
| **A "clean" template with no position** | Playing it safe | Static design has to take a position. Safe is invisible on a wall |

## Working order
1. **Fix the frame** (trim size, orientation, viewing distance, substrate — write them down), then **name the one message and the one feeling**: a fixed frame cannot say two things.
2. **If this is brand identity, do the logo system first**, in black and white, through the size ladder, before applying it to any medium.
3. **Thumbnail sketch the composition** before any type or color: entry, flow, anchor. If you cannot describe the eye path in one sentence, there is not one.
4. **Choose the display face** — highest-leverage decision in the piece, not from the ban list.
5. **Build the palette as OKLCH roles**, then convert for the output space and check the gamut.
6. **Compose with the ratio rule.** Big things big, small things small, nothing in the middle.
7. **Critique** with the core's six passes, weighting material honesty and the thumbnail test.
8. **Deliver** the Design Rationale, naming the composition structure, the display face and why, and any print specs the printer needs (stock, finish, spot inks, bleed, spine width).

## Generation checklist

*This is the builder's own list. It does not count as verification: the finish reviewer independently judges the rendered screenshots and its verdict is the only pass that matters.*

Run after the core pre-flight. Run every box before submitting to the reviewer.

**Frame**
- [ ] Trim size, orientation, viewing distance, and substrate declared before generating.
- [ ] Bleed 3mm on every printed piece; nothing critical inside 5mm of trim.
- [ ] Feed graphics keep critical content in the center 80%; 9:16 keeps the top 13% and bottom 22% clear.

**Composition**
- [ ] One named structure (center-dominant, thirds, diagonal, Z, F, full-bleed type), not a blend.
- [ ] Entry point, flow, and anchor describable in one sentence.
- [ ] Primary element **≥ 3× the secondary tier**.
- [ ] Squint test run: two clearly unequal masses, not an even field.
- [ ] Thumbnail test run at the format's real worst size (60px cover, 80px book, 25% social, 100px poster).

**Type**
- [ ] Typefaces ≤ 2 (3 only with a stated reason). Display face is not on the core ban list.
- [ ] Four tiers present and distinguishable without reading.
- [ ] Display tracking toward −0.02em, never past −0.04em. Not one letter-spacing value across all sizes.
- [ ] Optical kerning above ~36pt; punctuation hung; centered lines centered optically.
- [ ] Body measure 65–75ch. Light-on-dark compensated on leading, tracking, and weight.
- [ ] Print minimums met: no text below 7pt on cards, menus at 9pt or more, poster caps sized to distance.

**Color**
- [ ] Palette built as OKLCH roles first, then converted.
- [ ] Every color checked against CMYK gamut if it prints. Out-of-gamut identity colors specified as spot inks.
- [ ] Rich black C60 M40 Y40 K100 on large fields; K100 only on small text.
- [ ] Paper stock and its color accounted for in the palette.
- [ ] Handoff states that the palette is unproofed and asks for a hard proof.

**Material honesty**
- [ ] No procedural grain, no gradient standing in for light, no faked emboss or letterpress, no metallic gradient, no shape-assembled illustration.
- [ ] If the brief asked for a physical or photographic material, the output uses real material rather than a vector piece with a texture patched over it.
- [ ] Finishes (foil, letterpress, spot UV, edge paint) specified in the handoff, not simulated in the artwork.

**Marks**
- [ ] Recognisable at 16 / 32 / 60 / 240 / 480px.
- [ ] Works in solid black and solid white with no color.
- [ ] Silhouette is distinctive.
- [ ] With the name covered, the mark says something specific about this entity.
- [ ] System delivered: horizontal, stacked, icon, one-color, reversed, clear space as a fraction of a named element, minimum size for print and screen, do-not list.

**Tells**
- [ ] Not centered by default. No corner blob or diagonal stripe. No drop shadow behind the headline.
- [ ] No flat black overlay compensating for illegible type.
- [ ] No gradient background standing in for an undecided palette.
- [ ] No floating device in gradient space. No doodle accents. No stock-photo staging.
