# Reference — Imagery and assets

Loaded when the design needs images, or when a STYLE-DIRECTION reference
exists. The rule this file serves: **the medium is decided by what the design
promises, never by what feels buildable.** A photographic, textured, or
dimensional region is a raster asset, full stop; a CSS gradient or layered
background is not a texture medium.

## The style-extraction sheet

For every reference classified STYLE-DIRECTION in the brief contract, emit a
sheet into `work/brief-contract.md` (under the reference's entry) BEFORE
designing:

```
R1 style extraction:
- palette: <sampled roles, OKLCH>
- element inventory: <count and list the distinct visual elements in one
  frame: signage, light sources, materials, texture fields, figures>
- light behavior: <n sources, temperatures, glow y/n, haze y/n>
- density: <sparse | moderate | dense — how much of the frame carries content>
- carried per section: <for each section of the design, which of the above
  elements it reproduces WITH ITS OWN assets or devices>
```

The sheet exists because a Design Read compresses a reference into a vibe and
three dials — it structurally discards the reference's density, light, and
material inventory. Sampling a reference's palette while reproducing none of
its substance is the signature failure of machine design against a style
example, and the reviewer scores every fold against the reference on density,
light, and atmosphere, 0–4 each. Build to survive that scoring.

## The asset manifest

Before layout, list every image and video slot the design needs in
`work/assets/manifest.json`:

```json
{"slots": [{"region": "hero background", "medium": "raster",
            "status": "sourced|authored|LABELLED-PLACEHOLDER",
            "file": "work/assets/hero-bg.webp", "source_url": "...",
            "license_note": "..."}]}
```

Hard floor for art-led surfaces (games, film, music, fashion, events): **at
least 3 unique art assets or labeled slots; the same asset may never fill two
slots.** An art-led page with zero imagery is not minimalism, it is a bank
page wearing the brief's palette.

## The ladder — filling a slot without an image generator

1. **Real sourced imagery.** Fetch it (curl / python requests), save under
   `work/assets/`, record `{file, source_url, license_note, region}` in the
   manifest, and verify the bytes (non-zero, valid image header) — then
   reference locally; `file://` pages cannot depend on hotlinks. Search for
   the subject's physical object rather than the category; one decisive photo
   beats five mediocre ones. `https://picsum.photos/seed/<descriptive>/<w>/<h>`
   is legitimate for photographic placeholders when a real source fits nothing.
2. **Authored SVG or canvas — for geometry only.** Authored SVG covers what a
   session can specify exactly: diagrams with countable elements, controls,
   flat shape systems. It ends where drawing skill begins — a shaded,
   perspectived, or figure-bearing scene is a picture even in line-art style;
   a session cannot author it, so it does not pretend to.
3. **The honest labeled slot.** When neither is possible, ship a visible,
   deliberately designed placeholder that names its content — a slot styled
   in the world's own grammar carrying the label
   `IMAGE — <exact description: "rain-slick alley, stacked neon signage,
   figure in silhouette, teal-and-ember light">` — and add it to the user's
   replacement list in the final report. Unanswered promises present as
   marked placeholders, not omissions, and never silently as flat fields.
4. **Never:** a gradient or blurred color field standing where a photo was
   promised; CSS bevel/emboss imitating physical material; `feTurbulence`
   grain as fake texture; sketchy figure-bearing SVG scenes; emoji as
   imagery; div-built fake screenshots; and never, under any framing, the
   pixels of a STYLE-DIRECTION reference. These are the gap wearing chrome,
   and the reviewer treats them as **contradicted**, not missing.

## The atmosphere exemption

The material-honesty ban targets *faked physical materials* — imitation wood,
metal, paper, embossing. It does not ban light and air. **Particle fields,
haze layers, glow, vignettes, and weather are real material for a
screen-native medium** — they are authored, not imitated. When a brief
demands atmosphere (weather, mood, a world), building it from canvas
particles and layered translucency is the honest execution, and shipping
flat empty fields "to avoid fakery" is the dishonest one: it swaps a
deliverable the brief demanded for a compliance token.

Atmosphere earns its place like everything else: it must read at a glance in
a static screenshot (the reviewer only sees screenshots). If the weather is
invisible in every captured frame, it does not exist.

## How the reviewer scores a slot

- Real asset present and visibly shipped → `match`.
- Honest labeled slot → `missing`, with a material fix that says `produce:`
  or `source:` explicitly — never phrased as a style adjustment answerable
  with CSS.
- Broken load (console error, zero-byte, dead path) → `missing`, and a dead
  *control* (a play button over nothing) is contract-grade.
- Gradient / fake material standing in for promised material → `contradicted`
  — and contradicted MATERIAL on the focal element fires the rebuild
  directive.
- Asset at near-zero opacity or buried behind paint → compliance token →
  `contradicted`.
- User upload embedded without instruction, or STYLE-DIRECTION pixels found
  in the artifact → `added without approval`, ranked above all craft.
