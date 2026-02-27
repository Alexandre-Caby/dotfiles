---
name: aesthetic-craft-dataviz
description: Data visualization design intelligence. Use alongside the core aesthetic-craft skill when creating charts, graphs, infographics, data dashboards, analytical displays, or any visual representation of data. Covers chart selection, data-ink ratio, labeling, color in data contexts, dashboard composition, and data storytelling principles.
---

# Aesthetic Craft — Data Visualization

**Prerequisites**: Always read `aesthetic-craft/SKILL.md` (core) first. This sub-skill adds data-specific guidance.

---

## The Data Viz Mindset

Data visualization is not decoration. Its purpose is **clarity** — helping people see patterns, comparisons, and stories that are invisible in raw numbers. Every pixel either helps understanding or hinders it.

**The cardinal rule**: If someone has to *think* about how to read your chart, you've failed. The data should be immediately legible. The insight should follow within seconds.

**Three principles:**

1. **Data-ink ratio**: Maximize the share of ink (pixels) devoted to actual data. Minimize gridlines, borders, backgrounds, shadows, 3D effects, and anything that isn't information. (Credit: Edward Tufte)
2. **The right chart for the right question**: Bar charts compare. Line charts show change over time. Scatter plots reveal relationships. Pie charts almost never work. Choose based on what the data is *saying*, not what looks cool.
3. **Label directly**: If the reader has to look at a legend, then look at the chart, then look at the legend again — you've created unnecessary work. Label data directly whenever possible.

---

## Chart Selection Guide

Don't reach for the chart type you know best. Reach for the one that answers the question:

| Question the data answers | Best chart type | Avoid |
|---|---|---|
| How do these categories compare? | Horizontal bar chart (sorted by value) | Pie chart, 3D bars |
| How has this changed over time? | Line chart (time on x-axis) | Bar chart for many time points |
| What's the distribution? | Histogram, box plot, density plot | Pie chart, bar chart |
| What's the relationship between two variables? | Scatter plot | Line chart (implies time) |
| What's the composition / part-to-whole? | Stacked bar, treemap, waffle chart | Pie chart (unless 2-3 slices max) |
| What's the flow / process? | Sankey, flow diagram | Pie chart |
| What's the geographic pattern? | Choropleth map, bubble map | Bar chart by region name |
| What's the ranking? | Horizontal bar chart (sorted) | Vertical bar, radar chart |

### The Pie Chart Problem

Pie charts are almost always the wrong choice. Humans are bad at comparing angles and areas. Two exceptions:
- Exactly 2-3 slices where one is clearly dominant (e.g., 73% vs 27%)
- The audience specifically expects a pie chart (financial reporting conventions)

In all other cases, a bar chart or waffle chart communicates more clearly.

### The 3D Problem

Never use 3D effects on charts. 3D bars, 3D pies, perspective grids — they distort data and make accurate comparison impossible. 3D is decoration that actively lies about the values. The only valid 3D in data viz is actual 3D data (e.g., topographic maps, molecular structures).

---

## Data Viz Design Mechanics

### Color in Data

Color in data viz is functional, not decorative. Rules:

- **Sequential data** (low to high): Single-hue gradient. Dark = high. Light = low. Never rainbow.
- **Diverging data** (negative to positive, below/above average): Two-hue gradient with neutral midpoint. e.g., blue → white → red.
- **Categorical data** (groups): Distinct hues with similar saturation/lightness. Maximum 7-8 categories before it becomes unreadable.
- **Highlight strategy**: Use a muted palette for all data, then ONE vivid color to highlight the story. This is the most powerful technique in data viz.
- **Colorblind safety**: Never use red/green as the only distinction. Use blue/orange, or add patterns/shapes. Test with a colorblind simulator. ~8% of men can't distinguish your red from your green.

### Typography in Data

- **Chart titles**: Active, not passive. "Sales dropped 23% in Q3" > "Q3 Sales Data." The title IS the insight.
- **Axis labels**: Readable size (12px minimum). Horizontal when possible — rotated labels are hard to read.
- **Direct labels**: Place values on or next to data points instead of relying on axis gridlines. Remove the axis if direct labels make it redundant.
- **Units**: Always show units. "Revenue ($M)" not just "Revenue." "Temperature (°C)" not "Temperature."
- **Number formatting**: Use comma separators (1,000,000). Abbreviate large numbers (1.2M, $3.4B). Round to meaningful precision — $1,234,567 is noise when $1.2M tells the same story.

### Gridlines and Axes

- **Gridlines**: Light gray, thin, few. 3-5 horizontal gridlines max. Remove vertical gridlines unless scatter plot. If the direct labels make gridlines redundant, remove them entirely.
- **Axis lines**: Often unnecessary. The data and gridlines define the space. Remove axis lines if nothing is lost.
- **Zero baseline**: Bar charts MUST start at zero. Line charts can start elsewhere if the baseline is clearly labeled.
- **Axis ticks**: Reduce to minimum needed. Every tick mark the reader doesn't need is visual noise.

### Layout and Composition

- **Title at top left**: Where the eye goes first (in LTR languages).
- **Annotation > decoration**: Instead of decorative elements, add annotations that call out the key insight. An arrow pointing to the inflection point is worth more than any gradient background.
- **Small multiples**: When comparing many categories over time, small multiples (repeated small charts) beat one cluttered chart with 12 lines.
- **Aspect ratio matters**: Wide and short for time series (emphasizes trends). Tall and narrow for rankings. Square for scatter plots. Don't force all charts into the same box.

---

## Dashboard Composition

Individual charts are components. A dashboard is a **system** — multiple charts working together to tell a coherent story. Designing a dashboard is fundamentally different from designing a single chart.

### Dashboard Information Architecture

**Before choosing any chart, answer these questions:**
1. Who looks at this dashboard? (Executive summary vs. analyst deep-dive)
2. How often? (Daily glance vs. monthly review)
3. What's the first question they need answered? (That goes top-left, biggest)
4. What decisions does this dashboard drive? (Every chart should connect to a decision)

### The Dashboard Hierarchy

Not all charts on a dashboard are equal. Establish a clear visual hierarchy:

**Tier 1 — The headline metrics (KPI cards)**
- Top of page. Largest text on the dashboard. 3-5 maximum.
- Each KPI answers ONE question: "Are we on track?"
- Include context: value + comparison (vs. last period, vs. target, trend arrow)
- Bad KPI: "$684,000" (means nothing alone). Good KPI: "$684k ↑ 23% vs last year"

**Tier 2 — Primary charts (1-2 main visualizations)**
- The charts the user came here for. Largest chart area.
- Usually a time series or a comparison that shows the main story.
- Gets the most horizontal space and the best position (top, left of center).

**Tier 3 — Supporting charts (2-4 secondary views)**
- Context, breakdowns, drill-downs that support the primary story.
- Smaller. Below or to the right of the primary charts.
- A user might skip these on a quick glance but goes here when investigating.

**Tier 4 — Tables and detail data**
- Bottom of page. For users who need the raw numbers.
- Sortable, filterable, but not the visual focus.

### Dashboard Layout Principles

**Grid alignment**: All charts should sit on a shared grid. Misaligned chart borders create visual chaos — the eye notices tiny misalignments even if the brain doesn't consciously register them.

**Consistent chart height**: Charts in the same row should share the same height. Different heights in a row creates a ragged, unfinished look. Width can vary.

**Shared axes when possible**: If two charts show the same time period, align their x-axes. The reader can visually correlate across charts without thinking. Different time ranges for side-by-side charts is confusing.

**Shared color system**: All charts on a dashboard must use the same color palette and the same color meanings. If "revenue" is dark blue in one chart, it's dark blue everywhere. If "expenses" is gray in one chart, it can't be red in another. Build a dashboard color key and enforce it everywhere.

**Filter and control placement**: Filters at the top of the page, spanning the full width. They affect everything below. Don't bury filters inside individual charts — this confuses scope. Make it clear what the filter controls.

**Whitespace between charts**: Charts need breathing room. Cramming 8 charts into every pixel of a screen makes all of them worse. Use the spacing scale from the core skill. 16-24px between cards within a group, 32-48px between groups.

### Dashboard Density Spectrum

| Dashboard type | Density | # of charts | KPIs | Guidance |
|---|---|---|---|---|
| Executive summary | Low | 2-4 | 3-5 | Big numbers, simple trends, clear status. Glanceable in 10 seconds. |
| Operational / daily use | Medium | 4-8 | 3-6 | Balance between overview and detail. Users check this regularly. |
| Analyst / deep-dive | High | 6-12+ | 3-5 | Dense is fine — the audience expects it. But hierarchy still matters. Group related charts. |

### Dashboard Anti-Patterns

| Pattern | Problem | Fix |
|---|---|---|
| Every chart is the same size | No hierarchy — everything competes equally | Make primary charts 2-3x the area of secondary ones |
| KPIs without context | "684k" means nothing — is that good or bad? | Always include comparison: vs. target, vs. last period, trend |
| Inconsistent color meaning | Blue means revenue in chart 1 and users in chart 2 | One color = one meaning across the entire dashboard |
| Too many chart types | Bar, line, pie, donut, gauge, treemap, scatter — visual chaos | Limit to 2-3 chart types per dashboard |
| Charts that answer no question | "Here's a pie chart of our data" — so what? | Every chart must connect to a specific question or decision |
| No logical grouping | Random arrangement of charts | Group by theme: financial metrics together, usage metrics together, etc. |
| Filters with unclear scope | Does this date filter affect all charts or just this one? | Top-level filters = global. Per-chart filters labeled clearly. |

---

## Data Storytelling

A chart without a story is just a picture of numbers. The best data viz guides the reader to an insight.

### The Narrative Structure

1. **Setup**: What are we looking at? (Clear title, axis labels, context)
2. **Tension**: What's interesting or unexpected? (The dip, the spike, the outlier)
3. **Resolution**: What does it mean? (Annotation, subtitle, or accompanying text)

### Annotation as Storytelling

Don't make the reader figure out the story. Point to it:
- "Revenue peaked here before the policy change"
- "This cohort retained 3x better than average"
- Arrow + label on the exact data point that matters

Annotations are the single highest-impact addition to most charts. They transform data from something you *look at* into something you *understand*.

### Context Gives Meaning

Raw numbers are meaningless without context:
- **Comparison**: "23% churn" means nothing. "23% churn vs. 8% industry average" is a story.
- **Time**: "500 users" means nothing. "500 users, up from 50 six months ago" is a story.
- **Benchmarks**: Show reference lines for targets, averages, or historical baselines.

---

## Data Viz AI Anti-Patterns

| AI Pattern | What to Do Instead |
|---|---|
| Rainbow color palettes | Sequential or categorical palettes with purpose |
| 3D effects on charts | Flat, clean, 2D representations |
| Pie charts for everything | Bar charts, waffle charts, or treemaps |
| Decorative chart borders and backgrounds | Minimal chrome, maximum data |
| Every data point labeled (clutter) | Label key points only, or use direct labels strategically |
| Generic chart titles ("Sales Data") | Insight-driven titles ("Sales dropped 23% after launch") |
| Too many series on one chart | Small multiples or highlight one series at a time |
| Fancy animations on data | Static clarity beats animated confusion. Animate only to reveal sequence. |
| Using area/bubble size for precise values | Use length (bars) for precise comparison. Area for rough relative scale only. |
| Default Excel/Google Sheets styling | Strip chrome, fix colors, add direct labels, write a real title |
| Dashboard where every chart is identical size | Clear hierarchy — primary charts bigger, KPIs at top, supporting charts smaller |
| KPI cards showing raw numbers without context | Always pair with comparison, trend, or target |

---

## Data Viz Restraint

Data visualization has the LOWEST complexity budget of any design medium. The data IS the design. Everything else is in service of making the data legible.

**Remove until it breaks:**
1. Start with the default chart output
2. Remove the legend (label directly instead)
3. Remove gridlines (add back only if needed)
4. Remove axis lines (the data defines the space)
5. Remove tick marks (keep only the essential ones)
6. Remove borders and backgrounds
7. Reduce colors to the minimum that preserves meaning
8. What remains should be almost entirely data

**The Tufte test**: Print the chart in grayscale. Can you still read it? If the story depends entirely on color, it's fragile.

---

## Data Viz Accessibility

- **Colorblind-safe palettes**: Use blue/orange instead of red/green. Or use patterns/shapes alongside color.
- **Sufficient contrast**: Data marks against background must meet contrast standards.
- **Text alternatives**: Provide a text summary of the key insight for screen readers.
- **Font size**: Axis labels 12px minimum. Chart titles 14px minimum. Nothing smaller than 11px anywhere.
- **Pattern fills**: For distinguishing categories in print or for colorblind users, consider textured/patterned fills alongside color.

---

## Working Process for Data Viz

1. **What's the question?** What should the reader learn? Define the insight BEFORE choosing a chart.
2. **Choose the right chart**: Based on the question, not habit. Consult the selection guide.
3. **If dashboard**: Plan the hierarchy first — KPIs, primary charts, supporting charts, detail. Establish the shared color system and grid before building any individual chart.
4. **Build clean**: Minimal chrome. Direct labels. Insight-driven title. Appropriate color.
5. **Annotate the story**: Point to what matters. Don't make the reader hunt.
6. **Critique**: Run the core critique engine with data-specific checks: Is the chart type right? Could this be simpler? Is the title an insight? Would it work in grayscale? For dashboards: is the hierarchy clear? Are colors consistent? Does every chart answer a question?
7. **Deliver**: Share the Design Rationale with data-specific note on why this chart type was chosen.
