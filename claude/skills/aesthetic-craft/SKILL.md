---
name: aesthetic-craft
description: The complete design system for ANY visual output — web UIs, landing pages, React artifacts, dashboards, charts, posters, emails, slides, brand work, anything a human will look at, even when the user never says the word "design". Use it for creating, redesigning, or reviewing visual work of every kind. It runs a fixed pipeline — brief contract, direction, build, screenshot capture, then a mandatory finish review by an ISOLATED agent with authority to force rebuilds — and the deliverable only ships on that reviewer's verdict. Skipping this skill and generating from instinct produces machine-looking output that answers a different brief than the one given; skipping its review loop is how self-graded mediocrity ships. Read this file fully, then the reference files it names for the medium at hand.
---

# Aesthetic Craft

## Why this skill exists, and why it is shaped like this

Two failure modes account for nearly all bad generated design, and this skill
is engineered against both:

1. **Defaulting.** You reach for the statistical center before reading the
   brief: cream background, monoculture font, three cards, a kicker above the
   heading — or you sample a reference's palette and reproduce none of its
   substance, or you embed the client's mood image as production art. The fix
   is a written contract *before* any design thinking.
2. **Self-grading.** You verify what a script can count (contrast ratios,
   easing curves) and grade the rest of your own homework, then ship 10/10
   compliance that looks mediocre. A reviewer that inherits your transcript
   inherits your framing, your optimism, and your abstractions. The fix is
   architectural: **the disposition word comes from a context that never saw
   the build happen, and you repeat it verbatim.**

This file is the procedure. The knowledge lives in reference files loaded per
medium. The verdict lives with the finish reviewer. You never grade your own
work.

## The pipeline

```
0  Brief contract      references/brief-contract.md → work/brief-contract.md
1  Direction           mode + dials + register → direction contract in the artifact
2  Build               medium references · hero checkpoint · ≤2 self-inspection rounds
3  Capture             scripts/capture.py → work/shots/round1/
4  Mechanical scan     scripts/check_floor.py, once, after self-inspection
5  Finish review       SPAWN an isolated reviewer subagent — mandatory
6  Obey the verdict    rebuild | fix | ship · verdict pass · report verbatim
```

Every design job runs the full pipeline. There is no fidelity tier that skips
the review; a quick sketch is simply a smaller artifact through the same gate.

Create a `work/` directory next to the artifact (or in the session workspace)
for the contract, storyboard, shots, and review files. `<skill>` below means
this skill's own directory.

---

## Step 0 — The brief contract

Read `references/brief-contract.md` and execute it. Non-negotiables:

- Write `work/brief-contract.md` first: verbatim request, demand list (every
  demand → a visible deliverable), mood map (every mood word → a named visual
  device; copy is not a device), constraints, **reference triage**, register,
  glyph gloss if any.
- **Reference triage is the rule that must never be violated again.** Every
  uploaded image, link, or named example is classified in writing:
  STYLE-DIRECTION (pixels never appear in the deliverable, in any form) ·
  ASSET (user's words grant placement — quote the sentence) ·
  CONTENT-EXAMPLE · AMBIGUOUS (costs one question). Default when unstated:
  **STYLE-DIRECTION.** For each STYLE-DIRECTION image, emit the
  style-extraction sheet from `references/imagery.md`.
- **The question gate:** one round, 2–4 questions maximum, each tied to a
  specific demand or reference, each with 2–3 concrete options. Zero
  ambiguities → ask nothing. Unattended session → record the assumption and
  proceed.
- **The brief wins.** Pinned aesthetics, eras, fonts, and palettes override
  every default in this skill, including ban lists. Redirecting a clear brief
  toward your taste is failure. Refinement preserves everything outside
  scope; redesign only on explicit ask; never polish a look you were told to
  discard.

## Step 1 — Direction

**Mode** — what the visitor came to do (per surface, not per project):

| Mode | Visitor is here to… | Consequence |
|---|---|---|
| **Persuade** | Decide and act | Design is the product. Point of view mandatory. |
| **Operate** | Complete a task | Interface disappears into the work. Fixed scale, density a feature, motion 150–250ms. |
| **Read** | Understand | Measure, rhythm, hierarchy. Almost no ornament. |
| **Experience** | Be inside the work | Chrome recedes. Composition and material talk. |

**Dials** (1–10, baseline VAR 7 / MOT 5 / DEN 4): variance (symmetry →
asymmetric grids and deliberate voids; above 3, collapse to one column under
768px), motion (hover-only → entrances and reveals → scroll-driven sequences;
claimed motion is shown motion — if MOT > 4 the thing visibly moves, or drop
the dial and ship clean static), density (airy 96–128px sections → tight
tabular).

**Register** — the industry's visual dialect, named explicitly. Product-SaaS,
editorial, luxury, public-sector, **entertainment/game/film** (see
`references/web.md §Register`). Answering an art-led brief with a product
register is a misread of the same severity as Operate-designed-as-Persuade.

**Load the medium references** (read fully before building):

| Work | Read |
|---|---|
| Always | `references/craft-floor.md` |
| Browser-rendered UI, landing, artifact | `references/web.md` |
| Anything that moves or scrolls | `references/motion.md` |
| Charts, KPIs, dashboards | `references/dataviz.md` |
| HTML email | `references/email.md` |
| Posters, social, print, logos | `references/visual.md` |
| Any image slot, or a style reference exists | `references/imagery.md` |

**The direction contract**: five blocks (THESIS · OWN-WORLD · STORY · FIRST
VIEWPORT · FORM), 150 words max, written to `work/direction-contract.txt` AND
embedded as an HTML comment as the first child of `<body>` — it must survive
into the shipped file **byte-identical to the .txt**; the reviewer diffs the
two, and an edited copy is an audit failure ranked above all craft findings
(rewriting the contract to match what you shipped is the self-grading
pathology this pipeline exists to catch). If a block reads like a mood, the
direction is not decided yet. Close with the verbatim line:
`FINISH: unreviewed is unfinished; this build ends with the finish review and
the verdict.`

## Step 2 — Build

Build against the loaded references. Three artifacts are produced *during*
the build, not after:

- **Asset manifest** (`work/assets/manifest.json`, per
  `references/imagery.md`): every image/video slot with status
  sourced/authored/LABELLED-PLACEHOLDER. Art-led surfaces: ≥3 unique assets
  or labeled slots, no asset filling two slots, and never a
  STYLE-DIRECTION pixel.
- **Storyboard** (`work/storyboard.md`, per `references/motion.md §Macro
  choreography`) whenever anything is scroll-driven: scroll band → viewport
  contents → demand served. No empty viewport; budget ≤1.5× the unpinned
  height, arithmetic shown.
- **The two in-thread checkpoints** — the only self-checks you get:
  1. **Hero checkpoint.** As soon as the first viewport exists:
     `python <skill>/scripts/capture.py --html work/index.html --out
     work/shots/hero-check --hero-only`, then judge scale and density **as
     quantities** against the FIRST VIEWPORT block. A field at a tenth of the
     promised coverage or type at half the promised weight is a different
     design; a five-minute retry here is what a rebuild verdict costs later.
  2. **Bounded self-inspection: two rounds is the ceiling**, covering the
     whole cycle — screenshots, defect scans, micro-edits, rebuilds alike.
     Build fully, inspect once (desktop and mobile together), fix everything
     in one batch, confirm with at most one more round, stop polishing.
     Whatever remains ships through the review, where a fresh context does
     the finding better and cheaper.

## Step 3 — Capture

```
python <skill>/scripts/capture.py --html work/index.html \
    --out work/shots/round1 [--hover "a.cta-primary"] [--width 600]
```

Produces: hero + full-page + per-fold crops at desktop 1440×900 and mobile
390×844, mid-animation frames at 250ms and 900ms, a reduced-motion pass, the
console-error log, and the reduced-motion page height — the reviewer's whole
packet. Use `--width 600` for email. For print/poster work capture at the
artifact's own dimensions. If capture fails, pass whatever partials exist and
declare it (Step 5's degraded rules).

## Step 4 — Mechanical scan, once

After self-inspection is over (never before — deterministic findings anchor
judgment):

```
python <skill>/scripts/check_floor.py --html work/index.html \
    --attachments <every user-uploaded file> \
    --manifest work/assets/manifest.json --out work/floor-findings.json
```

It catches, deterministically: attachment pixels reused in the artifact,
dead resources behind controls, kickers, gradient text, fake grain,
zero-offset glows, monoculture fonts, em dashes in visible copy, and the
rest of the mechanically detectable Refuse list. Do not fix-and-rerun in a
loop; its findings travel to the reviewer as one packet entry. **Exception:**
an `attachment-reuse` or `dead-resource` error is a contract breach — fix it
immediately, recapture, and rerun the scan once; shipping it to review would
waste the round on a known P0.

## Step 5 — The finish review (mandatory, isolated)

**Spawning the reviewer as an isolated subagent is mandatory whenever a
subagent tool exists.** Running the review inline is a degraded run permitted
only when no such tool is exposed — "unavailable" means not exposed, **not
inconvenient**. Rules:

- Do NOT read `references/finish-reviewer.md` yourself — the reviewer reads
  it. Reading it invites pre-compliance and anchoring.
- Never paste your own description of the design, your section summaries, or
  your opinion of quality into the prompt. Paths only, plus the user's
  verbatim words.
- The reviewer has no browser; screenshots you fail to pass are checks it
  cannot run.
- Verify the return carries the disposition line and the five sections; on an
  empty or thrashed return, respawn once with the same inputs.

Spawn with exactly this prompt (fill the bracketed paths, nothing else):

```
Read <skill>/references/finish-reviewer.md and follow it exactly. It is your
entire job description. Your input packet:

- ORIGINAL REQUEST (verbatim): "<the user's request, quoted, unparaphrased,
  original language>"
- CONFIRMED USER ANSWERS: work/brief-contract.md
- ARTIFACT: work/index.html (and any files it loads)
- SCREENSHOTS: work/shots/round1/ (read manifest.json first)
- DIRECTION CONTRACT: work/direction-contract.txt
- APPROVED COMP / STYLE REFERENCES: <paths, or "none supplied">
- DETECTOR FINDINGS: work/floor-findings.json
- CRAFT FLOOR: <skill>/references/craft-floor.md
- ASSET MANIFEST: work/assets/manifest.json (or "none")

Return your review as specified in the brief: the disposition line first,
then exactly the five sections. Do not edit any file.
```

Save the return verbatim to `work/review-round1.md`.

**Degraded runs are declared, never silent.** If no subagent tool exists or
the spawn failed twice: step fully out of build context, run the review from
the reviewer brief inline, and the final report's first line MUST be
`⚠️ DEGRADED: single-context (<reason>)`. A silent degraded critique is a
failed critique.

## Step 6 — Obey the verdict

- **`rebuild`** — fidelity failed wholesale. Skip the fix batch, execute the
  rebuild immediately: re-derive the named regions, produce the named assets,
  recapture, and send back for a verdict — telling the user what is
  happening, not asking permission to fix a failure. Consult the user only on
  a *second* rebuild directive (both verdicts on the table) or when
  rebuilding would discard content they approved.
- **`fix`** — apply the material fixes in ONE batch, recapture the same
  viewports with the same script, and send the recaptures back for a
  **verdict pass**: a recapture measures positions and overflow; it cannot
  measure whether a fix reached the quality the finding named. Spawn a fresh
  subagent with:

  ```
  Read <skill>/references/finish-reviewer.md, section "Verdict Pass", and
  follow it exactly. Your prior review: work/review-round1.md (treat it as
  your own findings list). Post-fix recaptures: work/shots/round2/ (read
  manifest.json first). Artifact: work/index.html. Score every material fix
  resolved | partial | unresolved from what the recaptures visibly show.
  Return exactly two sections and the recomputed disposition line.
  ```

- **`ship`** — report and deliver.

**Budget:** fixes scored partial or unresolved get one more batch + recapture
+ verdict — two rounds is where an unattended run ends; an attended session's
ceiling belongs to the user: put the open table in front of them and let them
choose between shipping as-is and funding another round. Whoever decides,
**stop the moment a round resolves nothing**, and the reviewer's findings are
the only list you work from — never your own re-opened hunt.

**Reporting:** the final verdict table goes to the user as it stands, open
items included, under the reviewer's own disposition word. A table with open
material findings is never announced as a pass, and never under a softer
label than the reviewer wrote. Include the replacement list (labeled slots,
placeholder data) so the user knows what to supply.

---

## Non-web mediums

The pipeline is medium-independent; only the capture adapts:

- **Email**: capture at `--width 600`; the reviewer packet gains a dark-mode
  concern (see `references/email.md`).
- **Posters / print / social**: build the HTML at the artifact's true
  dimensions; capture full-page plus a thumbnail-scale render (the
  street-distance test lives in `references/visual.md`).
- **Charts and dashboards**: capture includes the states at 0, 1, and 500
  items when data is dynamic; `references/dataviz.md` governs.
- **Direct image/SVG deliverables**: wrap in a minimal HTML page for capture;
  the reviewer judges the rendered pixels the same way.

## Remember

- **The contract before the concept.** Every demand maps to something
  visible; a demand carried only by copy is a miss.
- **References are direction, not assets.** Embedding a user upload requires
  their words granting it. Default is STYLE-DIRECTION, always.
- **The brief wins** over every default in this skill.
- **Two self-inspection rounds, then hands off.** The reviewer's eyes are the
  only pass that counts, and its word ships verbatim.
- **Screenshots are the deliverable.** Nobody ships your source code; they
  ship what the captures show.
- **Atmosphere is material; emptiness is not restraint** when the brief asked
  for a world.
- Would a design director send it back? Then it is not done — and it is not
  your call to make.
