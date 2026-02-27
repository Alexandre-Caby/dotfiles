---
name: aesthetic-craft-web
description: Web-specific design intelligence. Use alongside the core aesthetic-craft skill when creating web UIs, React artifacts, landing pages, dashboards, web apps, HTML/CSS layouts, or any browser-rendered interface. Covers responsive design, web animation, interactive patterns, performance awareness, state design, and web-specific AI anti-patterns.
---

# Aesthetic Craft — Web

**Prerequisites**: Always read `aesthetic-craft/SKILL.md` (core) first. This sub-skill adds web-specific guidance.

---

## Web-Specific Design Awareness

### What Makes Web Design Feel Alive

- **Entry experience**: Staggered reveals, smooth fades, bold above-the-fold statements. The first 2 seconds determine if someone stays.
- **Scroll rewards**: Parallax, reveal-on-scroll, sticky elements that transform, progress indicators.
- **Micro-interactions**: Buttons that respond, cards that lift, toggles that snap. Small motions that say "someone thought about this."
- **Hover states that surprise**: Scale shifts, reveals, depth changes, content previews — not just color changes.
- **Transitions with character**: Page transitions, state changes, loading states — personality opportunities.

**Restraint note**: Dashboards need zero scroll rewards. Checkout flows need zero hover surprises. Match intensity to purpose.

### Responsive Design

A design that only works on desktop is half a design.

**Mobile-first thinking:**
- Start at 375px, expand up. More robust than collapsing from 1440px.
- Touch targets: 44x44px minimum. Fingers are not cursors.
- Thumb zones: Primary actions reachable with one thumb. Bottom > top for key CTAs on mobile.
- Content priority: On mobile, what's MOST important goes first.

**Breakpoint thinking:**
- Stack, don't shrink. Horizontal → vertical. Reorganize, don't miniaturize.
- Typography scales: 72px headline → 36-42px on mobile.
- Spacing compresses: Section 96px → 48-64px. Component 32px → 20-24px.
- Show/hide intentionally: Decorative elements can hide on mobile. Core content never hides.

**Responsive checklist:**
- Works at 375px, 768px, 1200px+?
- All interactive elements 44x44px on touch?
- Reading order makes sense when stacked?
- No horizontal overflow?

### Web Layout Mechanics

- **Max content width**: 680-720px for reading. 1000-1200px for app layouts. 480px for cards/mobile-first.
- **CSS Grid and Flexbox**: Use real grid systems, not approximate centering.
- **Z-axis**: Layering, overlapping elements, directional shadows create depth. Flat ≠ modern.

---

## Performance Is Design

A beautiful website that loads in 6 seconds is a bad website. Perceived performance directly affects how "quality" a site feels — a fast, smooth experience feels polished even with simpler visuals. A slow, janky experience feels broken regardless of aesthetics.

### Performance-Aware Design Decisions

| Design choice | Performance cost | What to do |
|---|---|---|
| Hero background video | Very high — large file, delays paint | Use only when video IS the product. Otherwise, still image or CSS gradient. |
| Parallax scroll effects | Medium — triggers repaints on scroll | Use sparingly. CSS `transform` only (GPU-accelerated). Never move large images on scroll. |
| High-res images everywhere | High — largest typical payload | Serve responsive sizes (`srcset`). Use WebP/AVIF. Lazy load below-fold images. |
| Custom web fonts (3+ weights) | Medium — render-blocking, layout shift | Limit to 2 weights. Use `font-display: swap`. Prefer variable fonts (1 file, all weights). |
| Complex CSS animations | Low-Medium | Animate only `transform` and `opacity` (GPU-composited). Never animate `width`, `height`, `top`, `left`, `margin`. |
| Large JavaScript bundles | High — blocks interactivity | If the design requires heavy JS (charts, maps, 3D), lazy load those components. |
| CSS blur / backdrop-filter | Medium — expensive on mobile | Avoid on elements that scroll or animate. Static use is fine. |
| Particle effects / canvas animations | High — continuous GPU cost | Reserve for hero moments only. Provide `prefers-reduced-motion` fallback. |

### The Performance Mindset

- **Every visual effect has a cost.** The question is whether it earns that cost in user experience.
- **Mobile is the constraint.** A 3-year-old phone on 3G is your real testing environment, not your MacBook Pro.
- **Fast AND beautiful > Beautiful AND slow.** When forced to choose, choose speed. Users forgive simple design. They don't forgive waiting.
- **Perceived performance**: Skeleton screens, progressive image loading, optimistic UI updates — these make things *feel* fast even when the network is slow. Design for perception, not just measurement.

---

## State Design — The Invisible 80%

The happy path (everything loaded, no errors, perfect data) is maybe 20% of what users actually experience. The other 80% is states most designers forget. These are where web design actually falls apart.

### Every Screen Has Multiple States

For any component or page, design ALL of these:

**Empty state** — No data yet
- Don't show a blank void. Show personality and guidance.
- "You haven't added any projects yet" + illustration + action button
- The empty state IS the onboarding. Make it helpful, not hollow.
- Bad: empty table with headers and no rows. Good: friendly message explaining what will appear here and how to get started.

**Loading state** — Data is coming
- Skeleton screens (gray shapes matching the content layout) > spinning wheels
- Progressive loading: show what you have, load the rest. Don't block the entire page for one slow API call.
- Maintain layout stability — content shouldn't jump when data arrives (Cumulative Layout Shift)

**Partial state** — Some data, not all
- One item in a list designed for twenty looks weird. Design for 1, 5, and 500 items.
- Long text truncation: how does a 3-word title and a 300-word title coexist in the same component?
- Missing fields: what happens when optional data isn't provided? The layout shouldn't break.

**Error state** — Something went wrong
- Be specific, not generic. "Couldn't load your projects — our server is having issues. Try again in a minute." > "Something went wrong."
- Offer recovery: retry button, alternative action, support link.
- Don't nuke the whole page for one failed component. Show the error inline where it matters.
- Error styling should be noticeable but not alarming. Red ≠ panic. A calm error message builds more trust than a screaming one.

**Success state** — Action completed
- Confirm clearly. A subtle checkmark animation, a brief toast, a color flash.
- Don't over-celebrate — "CONGRATULATIONS! 🎉" for saving a form field is patronizing.
- The success state should answer: "Did it work?" in under 1 second.

**Disabled state** — Can't interact right now
- Visually distinct (reduced opacity, muted colors) but still legible.
- Communicate *why* it's disabled. A tooltip or helper text explaining the condition beats a mystery gray button.

**Offline / degraded state** — Connection issues
- For apps that might be used offline or on poor connections: what still works? What doesn't? Tell the user.
- Cache what you can. Show stale data with a "last updated" note rather than nothing.

### Form Design States

Forms are state machines. Every input has: default, focused, filled, error, valid, disabled. Design all of them:

- **Focus**: Visible focus ring or border change. The user must know where they are.
- **Validation timing**: Validate on blur (leaving the field), not on every keystroke. Don't show errors before the user has finished typing.
- **Error messages**: Below the field, in context, in plain language. "Email is required" > "Validation error: field_email cannot be null."
- **Success indication**: Subtle checkmark or green border when a field passes validation. Reduces anxiety on long forms.
- **Multi-step forms**: Show progress. Let users go back. Don't lose their data.

### Feedback Patterns

| User action | Feedback needed | Timing |
|---|---|---|
| Click a button | Visual press state (scale down, darken) | Immediate (<50ms) |
| Submit a form | Loading indicator on the button, disable to prevent double-submit | Immediate, then result |
| Delete something | Confirmation dialog OR undo toast (not both) | Before deletion (confirm) or after (undo) |
| Toggle a setting | Visual state change + optional toast confirmation | Immediate |
| Drag and drop | Ghost element, drop zone highlight, snap animation | During drag, on drop |
| Background process | Progress bar or status indicator | Ongoing until complete |

---

## Web Accessibility Specifics

- **Focus states**: Every interactive element needs a visible focus indicator. Styled focus can be beautiful — glows, rings, subtle shifts. Not optional.
- **Semantic HTML**: Use real `<button>`, `<a>`, `<h1>`-`<h6>`, `<nav>`, `<main>`. Not styled divs.
- **Heading hierarchy**: H1 → H2 → H3 in order. Style with CSS, not by picking heading levels.
- **`prefers-reduced-motion`**: Provide alternatives. Animations enhance, not exclude.
- **`prefers-color-scheme`**: Consider supporting both light/dark if appropriate.
- **Alt text**: Informational images get descriptions. Decorative images get `alt=""`.
- **Keyboard navigation**: Tab order must be logical. Custom components need proper ARIA roles.

---

## Web AI Anti-Patterns

On top of the universal anti-patterns from the core skill:

| AI Pattern | What to Do Instead |
|---|---|
| Purple-blue gradient on white | Unexpected, context-driven palettes |
| Uniform rounded corners everywhere | Vary border radii — or use none |
| Cards in a perfect 3-column grid | Break the grid. Vary sizes. Overlap. |
| Generic hero + features + CTA layout | A layout that tells THIS product's story |
| Glass morphism by default | Depth techniques that serve content |
| Default shadows (0 4px 6px rgba) | Shadows that match your light source and mood |
| Same font (Inter, Space Grotesk) every time | Choose a typeface that fits the personality |
| Static pages with no motion | Thoughtful, purposeful animation where budget allows |
| Desktop-only designs | Responsive from the start |
| Only designing the happy path | Design empty, loading, error, partial, and success states |
| Heavy animations without performance thought | GPU-composited transforms only. Test on mobile. |
| Ignoring keyboard/focus states | Every interactive element needs visible focus |

---

## Modern Web Design Movements

Reference points, not a checklist:

- **Bento grid layouts**: Asymmetric card grids with varied sizes.
- **Neo-brutalism**: Thick borders, stark shadows, bold color blocks.
- **Kinetic typography**: Text that moves, morphs, or responds to interaction.
- **Claymorphism & soft 3D**: Pillowy elements with inner shadows.
- **Variable fonts**: Dynamic weight, width, optical size.
- **Oversized typography**: Massive display text as primary visual element.
- **Grain & texture**: Noise overlays, paper textures, film grain.
- **Cursor-driven interactions**: Custom cursors, magnetic elements, trail effects.

---

## Web Style References

- **Stripe / Linear / Vercel**: Precision + elegance. Dark themes, selective color, immaculate spacing. *For*: dev tools, premium SaaS.
- **Apple HIG**: Restraint as luxury. Massive whitespace, depth through blur. *For*: consumer, premium.
- **Airbnb / Figma**: Warm, human, rounded. Conversational UI, friendly motion. *For*: community, creative tools.
- **Brutalist / Raw**: System fonts, visible grids, bold blocks. *For*: portfolios, editorial, art.
- **Editorial / Magazine**: Typography-driven, dramatic scale contrasts. *For*: content-heavy, storytelling.
- **Gaming / Immersive**: Neon, particles, aggressive angles. *For*: entertainment, youth.
- **Calm / Tool**: Near-invisible UI. Neutral, consistent, clear. *For*: productivity, admin, repeat-use.

---

## Web Working Process

1. **Understand**: Who uses this? What device? What's the complexity budget? What states exist beyond the happy path?
2. **Commit**: Personality, emotional tone, memorable element, spacing/type/color systems.
3. **Build**: Responsive from start. Semantic HTML. Accessibility as you go. Design all states. Copy with same care as visuals.
4. **Performance check**: Are animations GPU-composited? Are images optimized? Does it feel fast on mobile? Are fonts loaded efficiently?
5. **Critique**: Run all 6 passes from the core critique engine. Include web-specific checks (responsive, focus states, semantic HTML, state coverage, performance).
6. **Deliver**: Share Design Rationale. Provide the output with confidence.
