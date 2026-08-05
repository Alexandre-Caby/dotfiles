# Reference — Data visualization

Loaded by aesthetic-craft's SKILL.md when the medium applies. The craft floor (references/craft-floor.md) applies on top of everything here. If the chart animates or responds to a pointer, also read `references/motion.md`.

If the separate `dataviz` skill is installed, take the palette values, mark specs, and library defaults from there and the judgment calls from here. Do not derive a second palette alongside one that already exists.

## The thesis

A chart is an instrument, not a picture: its job is to make a comparison the reader could not make from the numbers. Two consequences, and almost every bad chart violates one: **if the reader has to work out how to read it, it has already failed** (legibility is the whole deliverable), and **a chart that misleads is broken, not merely impolite** — a truncated bar baseline is a defect in the same category as an off-by-one, fixed immediately, without debate.

## Step 0 — the Chart Read

After the core Design Read, before any chart code, emit one line:

> **Chart Read:** *[the question]* → *[the finding]* → *[chart type]*, mode **[Operate | Persuade | Read]**, *n* series × *n* points.

Example: did the price change hurt revenue? → revenue fell 12% and has not recovered → line chart with an annotated event marker, mode **Persuade**, 1 series × 24 points.

**Why:** the finding decides the chart type, the color, the title, and whether a chart is warranted at all — writing it first stops you from producing a picture of the data and calling it analysis. If you cannot state the finding, the honest output is a table.

## Chart selection

Pick from the question, not from familiarity.

| The question | Use | Not | Why |
|---|---|---|---|
| How do these categories compare? | Horizontal bar, sorted by value | Pie, radar, 3D bar | Length on a common baseline is the most accurately read encoding there is. Sorting does half the analysis for the reader. |
| How has this changed over time? | Line, time on x | Bar for >12 periods, area for multiple series | Connection implies continuity; bars imply discrete independent quantities. |
| What is the distribution? | Histogram, box plot, strip or beeswarm plot | Bar of the mean | A bar of a mean hides variance, n, and outliers, which is usually the whole story. |
| How do two variables relate? | Scatter, with a fitted line only if the fit is stated | Line chart | A line between scatter points asserts an ordering that is not in the data. |
| Part to whole? | Stacked bar (one bar), waffle, treemap | Pie above 3 slices, donut | Only the first segment of a stack sits on a common baseline, so limit a stack to 3–4 segments. |
| Ranking? | Horizontal bar, sorted, labels left | Vertical bar with rotated labels | Category names read horizontally at any length. |
| Composition changing over time? | Stacked area (absolute) or 100% stacked (share) | Many overlapping lines | Pick one question: absolute or share. Answering both needs two charts. |
| Flow, conversion, routing? | Sankey, funnel with real drop-off labels | Pie | |
| Geographic pattern? | Choropleth for rates, proportional symbols for counts | Choropleth of raw counts | A choropleth of counts is a population map wearing a costume. |
| Two dimensions of category vs a value? | Heatmap with a sequential ramp | Grouped bars beyond 3 groups | |

**The encoding accuracy ladder** (Cleveland and McGill, in order of decoding precision): **position on a common scale > position on unaligned scales > length > slope or angle > area > volume or curvature > color lightness > color hue**. The rule that follows: **move the comparison the reader must make hardest up the ladder** — a precise comparison encoded in area or hue is a design decision to make it approximate. Hue is nominal; nobody can rank hues.

**When a number beats a chart:**

| n values | Deliver |
|---|---|
| 1 | The number, at display size, with one comparison (vs target, vs last period). A chart of one value is a decoration. |
| 2–3 | A sentence, or a small table. Two bars is a hard way to say "43 vs 61". |
| 4–8, no shape or order story | A sorted table with tabular numerals and a right-aligned value column. |
| 8+, or shape, trend, outliers, or distribution matter | A chart. Now it earns its space. |

A donut with one big number in the middle is the most common instance of this failure: if the value is not a proportion of the ring, the ring is a frame pretending to be an encoding.

## Titles carry the finding

The single highest-leverage change available in most charts, and it costs one line.

| Weak (names the variable) | Working (states the finding) |
|---|---|
| Revenue by month | Revenue fell 12% after the March pricing change |
| Churn rate, 2024–2026 | Churn has doubled since we moved upmarket |
| Support tickets by category | Billing drives 61% of tickets on 4% of the surface area |

Shape: **title = the finding (≤ 12 words), subtitle = the mechanics** — what is plotted, over what window, in what units, with what denominator ("monthly recurring revenue, USD, excluding trials, n=1,412 accounts" goes in the subtitle, never the title). Two constraints: the title must be **defensible from the chart in front of the reader** — no causal claim the data cannot support (write "after", not "because of"). And in **Operate** mode the tile keeps a stable label with the finding in an adjacent delta or status line, because a heading that rewrites itself hourly is unreadable at a glance.

## The numeric floor

Verify against computed values. Below this the chart is broken regardless of how it looks.

| Element | Floor |
|---|---|
| **Chart title** | ≥ 16px (18–20px on a standalone chart). Subtitle ≥ 13px. |
| **Axis tick labels** | ≥ 12px. 11px is the absolute floor, reserved for dense Operate surfaces and small multiples. Never below 11px anywhere. |
| **Direct labels and annotations** | ≥ 12px, ≥ 4.5:1 against whatever sits behind them, including the mark they label. |
| **Tick spacing** | ≥ 8px gutter between adjacent tick labels. If they collide, halve the tick count. Rotating is the third option, capped at 45°; on a category axis the right fix is a horizontal bar chart. |
| **Tick count** | 3–5 gridlines on the value axis. Ticks land on 1, 2, or 5 × 10ⁿ. Ticks at 0, 33.3, 66.7 mean the axis was divided rather than chosen. |
| **Gridlines** | 1px, alpha **0.06–0.12** on light backgrounds, **0.10–0.16** on dark (dark surfaces swallow low-alpha lines). Roughly 1.15–1.5:1 against the background: legible when sought, invisible when not. Horizontal only, except on scatter. |
| **Zero line / reference line** | 1px at 40–60% ink, heavier than a gridline. Target and benchmark lines dashed (4px on, 4px off) and labeled inline, never in the legend. |
| **Axis lines** | Default to none. The gridlines and the labels define the space. Keep the baseline on bar charts. |
| **Chart border and background** | None. Background matches the page or the card it sits in. |
| **Bar thickness** | ≥ 8px. Gap between bars 20–40% of bar thickness. In grouped bars the between-group gap is ≥ 2× the within-group gap, or the grouping does not read. |
| **Line stroke** | 2px for 1–4 series, 1.5px above that or in small multiples. Point markers ≥ 6px diameter when shown; show them below ~30 points, drop them above. |
| **Scatter points** | ≥ 4px diameter, alpha 0.6–0.8 once they overlap. Above ~2,000 points switch to hexbin or 2D density; an overplotted blob encodes nothing. |
| **Sparkline** | ≥ 20px tall, ≥ 60px wide, with the last value labeled. Below that it is a texture. |
| **Data mark contrast** | ≥ **3:1** against the background (WCAG 1.4.11, non-text graphical objects). Text labels ≥ **4.5:1**. Adjacent categorical fills that touch (stacks, choropleths, pies) need ΔL ≥ 0.12 in OKLCH between neighbors. |
| **Interactive hit target** | ≥ 24×24 CSS px (WCAG 2.2 minimum), ≥ 44×44 on touch. A 4px scatter dot gets an invisible hit region; a line chart gets a full-height voronoi or band overlay, not a 2px stroke you must hit. |
| **Aspect ratio** | Time series 2:1 to 3:1 (width:height), so the median segment slope lands near 45° and slope changes are readable. Scatter 1:1, since a stretched scatter distorts the perceived correlation. Horizontal bars: height = n × 28–36px, growing with the data rather than squeezing into a fixed box. Small multiple panel ≥ 160×100px. |
| **Series per chart** | ≤ 4 lines direct-labeled. 5–7 only with one highlighted and the rest muted. Above 7, small multiples. |

## Numbers as typography

**Tabular numerals are mandatory** (`font-variant-numeric: tabular-nums`) for every column of figures, axis tick, KPI tile, tooltip, and table cell — proportional digits give a ragged column and make a live number jitter; that is a rendering defect, not a preference. Right-align numbers, left-align text, align on the decimal, and use **one precision per column** all the way down — mixed precision breaks the decimal alignment and reads as a bug.

- **2–3 significant figures in a label.** `$1,234,567.89` in a chart is noise; `$1.23M` is the same fact.
- **Percentages: whole numbers when the spread is > 10pp**; one decimal only when the decision turns on tenths, never more than one in a UI. `34.2857%` is a division result, not a measurement.
- **Do not print more precision than the denominator supports.** With n=12, "58.3%" claims a resolution of 0.1 that 12 observations cannot carry. Rough guide: significant digits ≈ log₁₀(n).
- **Percentage points vs percent.** A move from 4% to 6% is +2pp, or +50%. Pick one, say which.
- **Units always, in the axis title or the tick suffix** — "Revenue ($M)", not "Revenue". A number with no unit is a rumor.
- Thousands separators above 4 digits. Dates as `15 Mar 2026` or ISO 8601, never `3/15/26`. Preserve the magnitude the reader thinks in (latency in ms, storage in GB, money in the story's units) — changing units mid-dashboard costs a conversion on every read.

## Color for data

Build in OKLCH with the core's color rules in force (chroma ceilings, white text on saturated mid-luminance fills, one locked palette per surface). Data color adds constraints because color is carrying information, not mood. **Never encode a quantity in hue alone** — hue is nominal; quantity goes in position, length, or lightness. A red-yellow-green "heatmap" ranks nothing; the reader consults the legend for every cell, exactly the work a chart should remove.

**Categorical:**
- **≤ 5 categories is comfortable; 7 is the hard ceiling.** Past 7 the reader is doing legend lookups: group the tail into "Other", split into small multiples, or highlight one and mute the rest. Grouping is an analysis decision and belongs in the subtitle: "top 5 plus other (n=23)".
- **Adjacent categories need ΔL ≥ 0.12 in OKLCH or Δhue ≥ 35° at comparable chroma** (both is better) — equal-lightness palettes look tidy in a swatch row and turn to mush at 4px.
- **The grayscale test is not optional.** If two categories collapse to the same gray, the chart fails in print, photocopy, projector, and for many color vision deficient readers — lightness variation is what makes a categorical palette survive.
- **~8% of men (1 in 12) and ~0.5% of women have a color vision deficiency**, deuteranomaly most commonly. Red versus green as the only distinction is out; blue versus orange survives nearly every type. Add a second channel where it matters: shape for scatter, dash pattern for lines (≥ 4px on/off so it reads at stroke width), direct labels for everything else.
- **One color, one meaning, across the whole surface.** If revenue is blue in the first chart it is blue in the ninth, and nothing else is blue.

**Sequential (low to high):**
- One hue, or a ≤ 40° drift toward yellow at the light end (buys extra discriminability).
- **Lightness varies monotonically**: roughly L 0.95 down to L 0.35 on a light background, equal ΔL steps, so ΔL ≈ 0.60 / (n−1) for n stops. 5–7 discrete stops; 9 is the ceiling.
- **Chroma peaks in the middle and falls at both ends**: ≤ 0.05 above L 0.90, ≤ 0.08 below L 0.30, ≤ 0.15 at the peak — otherwise the ends clip out of gamut and the ramp stops being monotonic in perceived brightness, the only property that made it a scale.
- Dark = high, light = low, always. Reversing it once in a dashboard is a bug the reader will never suspect.

**Diverging:**
- Two sequential arms sharing a neutral midpoint at L 0.92–0.97, chroma ≤ 0.02. **The arms mirror in lightness**, equal ΔL per step, so equal magnitudes read as equal intensity. Hue separation ≥ 120°, and not red/green: blue↔orange, purple↔green, teal↔red.
- **The domain is symmetric around the midpoint** (−x to +x) unless the asymmetry is stated in the legend — otherwise a 5% gain looks larger than a 5% loss and the chart is quietly arguing.
- **A diverging scale requires a meaningful zero**: an actual zero, a target, a period baseline, a named mean. Applied to data with no natural midpoint it invents a division the reader will believe — a false claim, not a styling flaw.

**The highlight strategy.** Mute every series to a neutral (ink at 20–35%), then give the one that carries the finding the single saturated color. The highest-value color move in data viz — it converts a chart into an argument without adding a pixel, and it answers "too many series" far more often than a bigger legend does.

## Mode awareness

The core's mode axis changes what a chart is allowed to do. Same data, different object.

| | **Operate** (dashboard read 50×/day) | **Persuade** (report, deck, pitch) | **Read** (article, docs) |
|---|---|---|---|
| Decoration | Near zero. Chrome disappears. | Annotation, emphasis, a stated conclusion. | Minimal, editorial. |
| Title | Stable label. Finding in the delta line. | The finding, in the title. | The finding, in the title. |
| Entrance animation | **None.** | None on the data. A scroll reveal of the whole figure is acceptable. | None. |
| Density | High. Tabular numerals, hairline rules, no card per chart. | Low. One idea per figure, room to annotate. | Medium. Figure sits in the text column. |
| Color | Restrained, semantic, locked. | Mute plus one highlight. | Restrained. |
| Interaction | Hover detail, cross-filter, drill-down, keyboard. | Usually static; it may be printed or screenshotted. | Static. Must survive as an image. |
| Precision | Exact values available on demand. | Rounded to the story's units. | Rounded. |

**Functional data the reader is reading should not move for style** — animating a chart's entrance makes a person wait for a number they came for, and on an Operate surface they pay that toll every visit. Per `references/motion.md`: transitions between *states* of the same chart (filter change, range change) are useful because they preserve object identity, at 200–300ms; an entrance stagger on load is decoration billed to the reader.

## The ways a chart lies

Craft, not ethics: each produces a chart that reports something other than what the data says, which makes it broken.

| Defect | What it does | Fix |
|---|---|---|
| **Truncated bar baseline** | Bars encode value as length, so a non-zero baseline multiplies the apparent difference. A 2% gap can be drawn as a 5× gap. | Bars start at zero. Always. If the differences are too small to see at zero, the chart type is wrong: use a dot plot, or plot the change directly. |
| **Truncated line axis** | Legitimate, and often correct, since lines encode change. But it is one round-number step from lying. | Start at a round number, label the axis clearly, never fill the area under a truncated line (fill re-encodes value as area, and the area is now false). |
| **Dual y-axes** | Two independently chosen scales can be slid until any two series appear to correlate. The reader cannot recover the choice you made. | Index both to 100 at a common start, or two stacked panels sharing an x-axis, or plot the ratio if the ratio is the point. |
| **Area for a linear quantity** | Circles and icons scaled by radius: doubling the radius quadruples the area, so the eye reads 4× for a 2× value. | Radius ∝ √value, and label the values. Better: use length. Applies to infographic icon scaling too. |
| **Inconsistent bin widths** | A histogram with uneven bins encodes count as height while the eye reads area, so wide bins are inflated. | Uniform bins, or plot density (count ÷ bin width) and say so. State the bin width; bin choice can create or erase a bimodal distribution. |
| **Cherry-picked range** | Any window can be found in which a trend reverses. | Show the full available series, or name the window and why. If a longer series exists, its absence is the claim. |
| **Missing denominator** | Raw counts across unequal populations. "Most incidents in the West region" when the West has 4× the accounts. | Rates per capita, per account, per opportunity. A count is only comparable across equal-sized groups. |
| **Unlabeled aggregation** | "Average" of what: mean or median, weighted how, over which window, excluding whom? A rolling average is a different series from the data. | Name the statistic and the window in the subtitle. Show n, and the spread when it matters (a bar of a mean with a 3× standard deviation is a lie of omission). |
| **Smoothed lines** | Spline interpolation invents values between real points, including maxima and minima that never occurred — a monthly series curving through a "peak" between two months is fiction. | Straight segments between points. Step interpolation for step functions (pricing, headcount, inventory). Curves only when the process is genuinely continuous and densely sampled. |
| **Unequal spacing on a time axis** | Points spaced evenly when the periods are not equal. | Continuous time axis with real spacing, gaps shown as gaps. |
| **Missing data drawn as zero** | Or silently interpolated across, which fabricates the most interesting part of the chart. | Break the line. Label the gap. A footnote naming the outage costs one line. |
| **Percent of a percent** | "Conversion improved 40%" when it went from 2% to 2.8%. | State both, and use pp for the absolute move. |

## The tell list — chart fingerprints

The recurring shapes of generated charts. Search your own output for these.

- **The default library palette, untouched** — matplotlib `tab10`, Chart.js pastel, Excel blue/orange/grey, Tableau 10. Recognizable at a glance.
- **Rainbow or viridis on categorical data** — viridis is a *sequential* ramp; on unordered categories it asserts an ordering that does not exist, and half its stops are indistinguishable at small sizes.
- **3D anything** — perspective makes near slices larger and rear bars shorter; the only legitimate 3D is genuinely 3D data (terrain, molecules, volumes). **Dual y-axes** and **truncated bar baselines** — see above.
- **A gradient fill under a line chart**, fading to transparent — implies an area encoding that carries no meaning and makes the axis region ambiguous.
- **Drop shadows on bars** — every shadow adds a few pixels of length to some bars and not others; depth on a 2D encoding is noise on the measurement.
- **A legend where direct labeling would work** — every legend read costs a saccade to the key and back, per series per glance. At ≤ 4 series, put the name at the end of the line or above the bar and delete the legend.
- **A border around every chart, and a card around every border** — chartjunk with a design-system alibi; whitespace separates, a box is a redundant second separator.
- **Smoothed / "monotone" curves between real data points.** **A donut with a big number in the middle** that is not a proportion of the ring.
- **An entrance animation on data the reader came to read** — bars growing from zero, lines drawing themselves (see `references/motion.md`).
- **Every point labeled**, so no point stands out — label the endpoints, the extremes, and the annotated point, nothing else.
- **Gauges and speedometers** — a quarter-circle of angle to encode one number, in the space where the number would fit ten times over.
- **Radar / spider charts** — area scales with the square of the values and the shape changes if you reorder the axes; legitimate only for 5–8 genuinely comparable, identically normalized dimensions.
- **Sparklines and progress rings standing in for content that does not exist** (from the core Refuse list).
- **Rotated 45° axis labels** as the reflex fix for crowding, instead of a horizontal bar chart. **A pie chart with 8 slices and a legend** — a sorted bar chart made unreadable.

## Dashboard composition

A dashboard is a system, not a wall of charts. **Answer four questions first:** who reads it, how often, what is the first question they need answered, and what decision does it drive — a chart that connects to no decision comes out. **Reading order:** the primary metric goes top-left (LTR), largest, alone in its visual weight; the eye enters there and fans right and down. If everything is the same size the reader has to build the hierarchy themselves on every visit.

| Tier | What | Rules |
|---|---|---|
| 1 | Stat tiles / KPIs | 3–5 max, one row. Each is value + comparison + direction. `$684k` alone is not a KPI; `$684k, +23% vs LY` is. Tabular numerals. |
| 2 | The primary chart | One per view. 2–3× the area of any secondary chart. The reason the page exists. |
| 3 | Supporting charts | 2–4. Breakdowns and context. Smaller, below or right. |
| 4 | Detail table | Bottom. Sortable. Not the visual focus. |

**Apply the core's cognitive rules literally:** ≤ 4 items per visual group, ≤ 4 sibling choices at a decision point — so ≤ 4 tiles per row, ≤ 4 charts per titled group. Above that, add a group heading and a gap rather than another column.

Consistency rules that make a dashboard read as one instrument:

- **One color, one meaning**, enforced across every chart. **≤ 3 chart types per view** (bar, line, and one more) — seven chart types is visual chaos wearing the word "rich".
- **Shared x-axis domains** for charts covering the same period, aligned left edge to left edge so the reader can correlate vertically without thinking.
- **Small multiples share the y-axis domain.** Independent y-scales per panel is the single most common small-multiples error: it makes every panel look identical and destroys the comparison the format exists to enable. If one panel's range genuinely dwarfs the rest, say so and consider a labeled log scale or a separate panel.
- **Equal heights within a row** (widths may vary; ragged bottoms read as unfinished). **Spacing from the core scale:** 16–24px between charts in a group, 32–48px between groups — the gap is the grouping mechanism, so an inconsistent gap silently regroups the page.
- **Filters at the top, full width**, because that is what "global" looks like. A filter inside a chart card controls that card only, and must be labeled as such.

**Density by audience:** executive 2–4 charts, glanceable in 10 seconds. Operational 4–8. Analyst 6–12+, where density is a feature and hierarchy still is not optional.

## Interaction and accessibility

- **Tooltip:** anchored to the mark with an 8–12px offset, never covering it, never lagging behind the cursor. ≤ 5 rows: category name, value with units, the comparison. Appears in ≤ 150ms with no entrance animation on the number.
- **Hover bands, not hairlines.** On a time series, hover the whole vertical band for a period and show all series at that x — hitting a 2px line is a dexterity test.
- **Keyboard:** the chart is focusable, arrow keys step through points, the focused value is announced. If that is out of scope, ship the data table instead of an inaccessible chart.
- **Text alternative:** one sentence with the chart type, what is plotted, the range, and the finding — "Line chart of monthly revenue, Jan 2024 to Jun 2026, ranging $410k to $890k; revenue fell 12% after March 2026 and has not recovered." Doubles as the caption for a skimming reader.
- **Respect `prefers-reduced-motion`** (state transitions become instant), and **never rely on color alone** — shape, dash pattern, direct label, or position must carry the same distinction.

## Restraint: remove until it breaks

Data viz has the lowest complexity budget of any medium (core: Low). Start from the library default and delete, in this order, checking legibility after each step: legend (direct-label instead) → gridlines → axis lines → tick marks → borders and card chrome → colors beyond the minimum that preserves meaning → labels beyond the endpoints and the annotated point. What remains should be almost entirely data — Tufte's data-ink ratio as a procedure rather than a slogan. Then add back exactly one thing: **the annotation that names the finding.** An arrow and six words on the inflection point is worth more than every gradient you did not add.

## Generation checklist

*This is the builder's own list. It does not count as verification: the finish reviewer independently judges the rendered screenshots and its verdict is the only pass that matters.*

Run after the core pre-flight. Run every box before submitting to the reviewer.

**Decision**
- [ ] Chart Read declared: question, finding, chart type, mode, series × points.
- [ ] Chart type chosen from the question, and the hardest comparison sits high on the encoding ladder.
- [ ] n=1 printed as a number, not drawn as a chart. n ≤ 5 with no shape story delivered as a table.
- [ ] Title states the finding (Persuade / Read) or the tile carries a stable label with the delta beside it (Operate).
- [ ] Subtitle names units, window, denominator, and n.

**Numbers**
- [ ] Tabular numerals on every figure column, axis, tile, and tooltip.
- [ ] ≤ 3 significant figures. Percentages ≤ 1 decimal. Zero instances of 3+ decimals on a percentage.
- [ ] One precision per column. Numbers right-aligned, decimals aligned.
- [ ] Every axis and every tile carries its unit.

**Marks and type**
- [ ] Axis labels ≥ 12px (11px floor in dense Operate). Title ≥ 16px. Nothing below 11px.
- [ ] 3–5 gridlines, alpha 0.06–0.12 light / 0.10–0.16 dark, horizontal only. No chart border. No card-inside-card.
- [ ] Bars ≥ 8px thick, gap 20–40% of thickness. Lines 2px. Scatter points ≥ 4px.
- [ ] Aspect ratio: time series 2:1–3:1, scatter 1:1, horizontal bars sized by n.
- [ ] Data marks ≥ 3:1 against background; labels ≥ 4.5:1; touching fills ΔL ≥ 0.12.
- [ ] Interactive targets ≥ 24×24 (≥ 44×44 on touch), including invisible hit regions for small marks.

**Color**
- [ ] ≤ 5 categories (7 absolute ceiling); the tail grouped and the grouping stated.
- [ ] Palette survives the grayscale test and a deuteranopia check. No red/green as the only distinction.
- [ ] Sequential ramp: monotonic lightness, chroma reduced near white and black, dark = high.
- [ ] Diverging ramp: mirrored lightness arms, symmetric domain, and a zero that means something.
- [ ] No quantity encoded in hue alone. One color, one meaning, across every chart on the surface.

**Truth**
- [ ] Bar baselines at zero. Truncated line axes labeled and unfilled.
- [ ] Dual y-axes: **0**.
- [ ] Area or radius encodings use √value; nothing linear is encoded as area.
- [ ] Uniform bins, stated bin width, real time spacing, gaps shown as gaps.
- [ ] Denominators present wherever groups differ in size. Aggregations named with window and n.
- [ ] No spline smoothing between discrete observations.

**Tells and finish**
- [ ] No default library palette, 3D, gauge, radar, drop-shadowed bar, decorative gradient fill, or donut standing in for a non-proportion.
- [ ] No entrance animation on data. State transitions 200–300ms, `prefers-reduced-motion` respected.
- [ ] Legend deleted at ≤ 4 series in favor of direct labels; ≤ 3 chart types per dashboard.
- [ ] Small multiples share a y-domain; charts of the same period share an x-domain.
- [ ] One annotation names the finding.
- [ ] Text alternative written: chart type, variables, range, finding.
