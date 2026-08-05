# The Brief Contract

The single most expensive failure mode in delegated design is not bad taste,
it is a deliverable that answers a different brief than the one given. This
file is the procedure that prevents it. Run it before any design thinking —
before the Design Read, before a palette, before a single line of markup.

## The sovereignty rules

- **The brief wins.** Honor pinned aesthetics, eras, materials, fonts, and
  palettes even when they conflict with a saturated-pattern warning or a
  default in the craft floor. Redirecting a clear brief toward your own taste
  is failure, not craft. A brief-pinned world pins the world, not its softest
  rendition — the pinned world's full material range stays in play.
- **Refinement vs redesign.** Refinement preserves the incumbent identity,
  behavior, copy, and everything outside scope; "everything else stays" is a
  literal instruction. Redesign keeps product truth, content, function, and
  constraints, but treats the old look as evidence and anti-reference. Never
  split the difference into polish on the discarded look. Redesign triggers
  ONLY on the user's explicit ask in the current request; unsure means
  refinement, because a wrong refinement is recoverable and a wrong redesign
  is not.
- **Constraints rule out devices, not energy.** "No gamification" rules out
  badges, streaks, confetti; it does not rule out energy. Adjectives
  describing the product's behavior (quiet support, calm coaching) do not
  dictate the surface's energy.

## The contract file

Write `work/brief-contract.md` in this exact shape:

```markdown
# Brief Contract
REQUEST (verbatim): "<the user's words, quoted, unedited, original language>"

## Demands            <!-- every demand maps to a deliverable; nothing implied is dropped -->
D1. "<quoted fragment>" → deliverable: <what will visibly exist> [status: pending]
D2. ...

## Mood map           <!-- every mood word gets a named visual device -->
M1. "<sinister>" → device: <occlusion haze / vignette / accumulation / flicker / broken grid>
                   <!-- "the copy expresses it" is not a device -->

## Constraints        <!-- negative space: what was ruled out -->
C1. "<no gamification>" → rules out: <badges, streaks, confetti>; does NOT rule out energy

## References         <!-- every uploaded image, link, or named example -->
R1. <file/url> → STYLE-DIRECTION | ASSET | CONTENT-EXAMPLE | AMBIGUOUS — <one-line reason,
    quoting the user's words that decide it>

## Register           <!-- the industry's visual dialect; see references/web.md §Register -->
<product-SaaS | editorial | entertainment/game | luxury | public-sector | ...>

## Glyph gloss        <!-- only if non-English decorative text will appear -->
G1. <glyph> → <meaning> → <why it belongs on this element>

## Open questions     <!-- empty, or the 2–4 questions of the single round -->
## Answers            <!-- filled after the round; then statuses update -->
```

## Reference triage — the rule that must never be violated again

Every attached file, pasted link, or named example is classified, in writing,
before generation:

- **STYLE-DIRECTION** — the user's words point at its *qualities*: "like
  this", "in this style", "un exemple de", a competitor link, a mood image.
  Its pixels **never appear in the deliverable in any form** — not embedded,
  not cropped, not as a poster, not "just as a placeholder". Only its grammar
  is learned, through the style-extraction sheet (references/imagery.md).
- **ASSET** — the user's words instruct placement: "use this photo", "here's
  our logo", "put this in the hero". Quote the granting sentence in the
  contract. It is embedded verbatim, never regenerated, restyled, or cropped
  beyond layout needs without instruction.
- **CONTENT-EXAMPLE** — sample data, copy drafts, structure examples: informs
  content, never rendered as-is unless also granted as ASSET.
- **AMBIGUOUS** — costs one question in the single round: "Should I place
  this image on the page, or use it as style direction only?"

**The default, when the user's words don't grant placement, is
STYLE-DIRECTION.** Embedding a user upload requires explicit instruction —
there is no "it was the only image I had" exception; the imagery ladder
(references/imagery.md) exists precisely for that case. The finish reviewer
and the mechanical scanner both check this: an upload's bytes found in the
artifact without a quoted ASSET grant is a contract violation ranked above
every craft finding.

## The question gate

At most **one round**, **2–4 questions maximum**, and only when the contract
has genuine ambiguities:

- Each question references a specific demand, reference, or constraint —
  never generic ("who is your audience?" is banned).
- Each offers 2–3 concrete options plus free text.
- Skip settled facts; a precise request may need only a compact confirmation.
- Ask about: what success looks like, what must remain untouched, what would
  make a polished result feel wrong, and any AMBIGUOUS reference.
- Zero ambiguities → ask nothing and proceed. Do not ask for CSS values or
  canned aesthetic lanes.

When the session is unattended, resolve ambiguities with the most defensible
reading, record the assumption in the contract under Answers, and state it in
the final report.

## The direction contract

After the brief contract and before code: five blocks, 150 words total
maximum, written to `work/direction-contract.txt` AND embedded as an HTML
comment as the first child of `<body>` (it must survive into the shipped file
— the reviewer checks):

- `THESIS` — the one idea this surface owns, and the category-default
  arrangement it refuses.
- `OWN-WORLD` — palette and component language, specific enough to be
  recognizable with all content removed.
- `STORY` — what the visitor understands, believes, does.
- `FIRST VIEWPORT` — exact composition: what is where, at what scale, where
  the primary action sits.
- `FORM` — the chosen form and its position on the candidate list.
- Closing line, verbatim: `FINISH: unreviewed is unfinished; this build ends
  with the finish review and the verdict.`

If a block reads like a mood, the direction is not decided yet. The finishing
review audits the render against this contract.

## Truth

Truth binds claims, not demonstrations: author whatever illustrative material
the concept needs at full fidelity, label it synthetic wherever a visitor
could mistake it for the real thing, and hand the user the list of what to
replace. What stays uninventable are commercial and factual claims: prices,
customers, benchmarks, capabilities the product does not have. Refusing a
bold direction because its demonstration data does not exist yet is the
timidity reflex wearing honesty's clothes.

A control may never ship pointing at a nonexistent resource. If the video
does not exist: a poster with a visible label and an external link, never a
playable-looking dead shell.
