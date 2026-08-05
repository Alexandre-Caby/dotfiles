# Reference — Motion

Loaded by aesthetic-craft's SKILL.md whenever anything moves. The craft floor (references/craft-floor.md) applies on top. For browser-rendered work, also load references/web.md.

Generated interfaces give themselves away through motion that is wrong in small, compounding ways: `ease-in` on an entrance, 400ms where 180ms belonged, a popover scaling from screen center instead of its trigger, a keyframe restarting from zero on a double click, motion on an action performed two hundred times a day. The correct answers are known and written below. **The first question is always whether to animate at all** — the highest-value fix in this skill is deletion.

## The decision framework

Answer all four, in order, before writing any code. **1. Should this animate at all?** Frequency decides:

| Frequency | Decision |
|---|---|
| **100+ times a day** — keyboard shortcuts, command palette, tab switching | **No animation. Ever.** |
| **Tens of times a day** — hover effects, list navigation, filters | Remove it, or reduce it drastically |
| **Occasional** — modals, drawers, toasts, sheets | Standard animation |
| **Rare or first-time** — onboarding, empty states, success, celebration | Delight is welcome here |

Raycast has no open/close animation — correct for something opened hundreds of times a day. **Keyboard-initiated actions are a disqualifier, not a judgment call** — animation makes a keyboard action feel delayed and disconnected from the key. **Data the user is trying to read or act on does not move for style** — an animated line-draw on a banking chart delays the number they came for.

**2. What is the purpose?** Name it from this list; if you can't, don't animate. "It looks cool" on a frequently-used surface is not a purpose.

| Purpose | Example |
|---|---|
| **Spatial consistency** | A toast enters and exits from the same edge, so swipe-to-dismiss feels obvious |
| **State indication** | A button morphs to show the state actually changed |
| **Explanation** | A marketing animation showing how a feature works |
| **Feedback** | A button scales down on press, confirming the interface heard you |
| **Preventing jarring change** | Things appearing and vanishing with no transition read as broken |
| **Delight** | Permitted only at the rare / first-time tier |

**3. What easing?**

```
Is the element entering or exiting?
  Yes → ease-out                    (starts fast, feels responsive)
  No  → Is it moving or morphing on screen?      → ease-in-out
        Is it a hover or color change?           → ease
        Is it constant motion (marquee, bar)?    → linear
        Otherwise                                → ease-out
```

**`ease-in` on a UI interaction is always wrong** — it starts slow, delaying movement exactly when the user watches most closely. `ease-out` at 200ms *feels* faster than `ease-in` at 200ms.

**4. How fast?**

| Element | Duration |
|---|---|
| Button press feedback | **100–160ms** |
| Tooltips, small popovers | **125–200ms** |
| Dropdowns, selects, menus | **150–250ms** |
| Modals, drawers, sheets | **200–500ms** |
| Marketing and explanatory | Longer is allowed |

**UI animation stays under 300ms** — long feedback reads as latency, not elegance. On **Operate** surfaces (see SKILL.md), keep most transitions to **150–250ms** and don't orchestrate page-load sequences at all.

## Macro choreography — scroll as a sequence

Micro rules cannot catch page-scale failures: content evacuating before its replacement arrives, scenes holding nothing, scroll inflated past what the content justifies. **The storyboard artifact is mandatory before any scroll-driven code.** Write `work/storyboard.md` first: a table of scroll % (or px band) → what occupies the viewport → which brief-contract demand it serves. It must satisfy all four rules **before** coding:

1. **No empty viewport, ever.** Outgoing content overlaps incoming within half a viewport of scroll — if scene A's exit completes at 60% of a band, scene B is arriving by then, not waiting at 90%. An empty scroll band is a P0 the reviewer will catch.
2. **Scroll budget: total page height ≤ 1.5× the reduced-motion (unpinned) height**, arithmetic shown in the storyboard. Over 1.5× the motion layer is inflation — fix by compressing scenes, not lengthening the fallback.
3. **Every pinned scene earns its scroll.** A scene spending more than one viewport on a single sentence must name what else the frame is doing during the hold (an image developing, atmosphere, a reversal). "Held for pacing" with a static frame is a dead frame.
4. **Beats carry content, not just motion.** Each row names what the reader learns or feels there; motion beats without content beats are decoration — cut or give them a job.

**The inflation test.** The reviewer renders the reduced-motion fallback beside the animated page. If the fallback reads as the better-composed page, the motion layer failed wholesale and the verdict returns the entire layer. A sequence obeying the overlap rule and the 1.5× budget cannot out-inflate its own content.

**Choreography vocabulary** — fades are the default because they require no thought; reach instead for: **wipes and shutters** (`clip-path` reveals that sweep or split, giving an edge instead of a dissolve) · **reversals** (a surface takes the page over, holds a beat, hands it back — high impact, spend it once) · **counter-motion** (foreground and background in opposition, making depth legible) · **occlusion** (content passing in front of and behind other content; the z-order must actually interleave, or the "atmosphere" layer reads as wallpaper) · **development** (an image or field that accumulates as you scroll, so the held frame is always becoming something). One authored signature moment beats five scattered reveals: give the scene the brief cares about most the strongest device.

## Easing curves

The built-in CSS easings are too weak to read as intentional. Use these:

```css
:root {
  --ease-out:    cubic-bezier(0.23, 1, 0.32, 1);   /* UI enter/exit — the workhorse */
  --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);  /* on-screen movement, morphing */
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);   /* iOS-like drawer/sheet curve */
  --ease-reveal: cubic-bezier(0.16, 1, 0.3, 1);    /* confident scroll-reveal arrival */
}
```

Don't invent curves — take variants from a curve library, not guessed control points. **Never `bounce`, `elastic`, `wobble`, or `spring` keyframe names by reflex:** bounce is earned by momentum the user supplied (a flicked card), never applied as decoration (a menu that just faded in).

## Transforms and physicality

**Animate only `transform` and `opacity`** — they run on the compositor; animating `width`, `height`, `padding`, `margin`, `top`, or `left` forces layout, paint, and composite every frame. Exceptions must be *argued* in a comment (animating `width` on a 28px absolutely-positioned element with no layout dependents costs nothing; on a sidebar it costs everything).

| Move | Value |
|---|---|
| **Press feedback** | `transform: scale(0.97)` on `:active`, `transition: transform 160ms var(--ease-out)`. Band: **0.95–0.98**. Applies to *any* pressable element. |
| **Entrance scale** | Start at **`scale(0.9)`–`scale(0.97)`**, paired with `opacity: 0`. |
| **Never** | `scale(0)`. Nothing real appears from nothing — a deflated balloon still has a shape. |
| **Offscreen positioning** | `translateY(100%)` / `translateY(-100%)` — percentages adapt to the element's own size; prefer over hardcoded pixels. |
| **Stagger offset** | `translateY(8px)` → `translateY(0)` |
| **Hover scale** | `scale(1.05)`, gated behind `@media (hover: hover) and (pointer: fine)` |

`scale()` scales children — font size, icons, padding — which is what makes a press feel like a press.

**Stagger: 30–80ms between items, 50ms default** — longer feels slow rather than choreographed. Stagger is decorative: **never block interaction while it plays**, and it belongs where a list genuinely appears as a list, not on every scrolled section.

**Asymmetric timing: slow where the user is deciding, fast where the system is responding.** The canonical case is hold-to-confirm:

```css
.overlay          { transition: clip-path 200ms var(--ease-out); }  /* release: instant */
.button:active
  .overlay        { transition: clip-path 2s linear; }              /* press: deliberate */
```

Two seconds to commit, 200ms to abandon. Symmetric timing on a press-and-release interaction is a bug.

## Origin-aware motion

**A popover scales in from its trigger, not from the center of itself** — `.popover { transform-origin: var(--transform-origin); }` set from the trigger's position. The default `transform-origin: center` is wrong for nearly every anchored surface: dropdowns, tooltips, menus, popovers, context menus, sheets that spring from a control. **Modals are the exception** — unanchored, they legitimately keep `transform-origin: center`; don't "fix" one or report it as a finding.

**Enter and exit along the same path** — in-from-right, out-the-bottom feels disconnected; mirror the easing on reversible transitions. **Hint in the direction of the gesture:** people predict the final state from the trajectory, so make in-between frames point at the outcome.

## Interruptibility

The single most important principle in interactive motion, and the one most often missing.

| Mechanism | On interrupt |
|---|---|
| **CSS transitions** | Retarget smoothly from the current value |
| **CSS `@keyframes`** | **Restart from zero** — visible jump |
| **Springs** | Maintain velocity through the reversal |

**For anything triggered rapidly — toasts stacking, a spammed toggle, an accordion opened then closed — use transitions or springs, never keyframes** (a keyframe snaps to the start and replays). Avoid CSS transitions and keyframes entirely for gesture-driven motion; they can't be grabbed and reversed mid-flight.

- **Never lock out input during a transition** (the thought and the gesture happen in parallel), and **animate from the *presentation* value, not the target value** — on interrupt, start from where the element actually is on screen, or you get a visible jump.
- **When a gesture reverses, blend the velocity — don't hard-cut it.** Decide reverse-versus-commit by the **sign of the velocity at release**, not by position.

## Springs

Two ways to specify; duration-and-bounce is easier to reason about:

```js
{ type: "spring", duration: 0.5, bounce: 0.2 }              // preferred
{ type: "spring", mass: 1, stiffness: 100, damping: 10 }    // more control
```

**Keep bounce in the 0.1–0.3 band when used at all; default `bounce: 0` for ordinary UI** — bounce is for drag-dismiss and playful moments, motion the user's own hand started. In damping/response terms: **damping** `1.0` is critically damped, no overshoot; below 1.0 overshoots, lower is bouncier. **Response** is seconds to reach the target — *not* a duration; a spring has no fixed duration.

| Interaction | Damping | Response |
|---|---|---|
| Move / reposition | 1.0 | 0.4 |
| Rotation | 0.8 | 0.4 |
| Drawer / sheet | 0.8 | 0.3 |

Start most UI at damping 1.0. **Decompose 2D motion into independent X and Y springs** — a single spring driving a 2D distance desyncs the moment the axes have different velocities.

## Gesture physics

For drags, swipes, sheets, and carousels, these constants make it feel native rather than scripted. **Dismiss on velocity, not just distance** — a quick flick should be enough:

```js
const velocity = Math.abs(swipeAmount) / timeTaken;   // px per ms
if (Math.abs(swipeAmount) >= SWIPE_THRESHOLD || velocity > 0.11) dismiss();
```

**Momentum projection** — where a flick would naturally land. The physics-textbook `v²/(2·decel)` is *not* what shipping bottom-sheets and carousels use; use this exponential-decay form:

```js
// decelerationRate ≈ 0.998 for normal scroll feel; 0.99 for snappier
function project(initialVelocity /* px/s */, decelerationRate = 0.998) {
  return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate);
}
```

**Rubber-banding at boundaries** — the further they drag, the less it moves; real things slow before they stop rather than hitting an invisible wall:

```js
function rubberband(overshoot, dimension, constant = 0.55) {
  return (overshoot * dimension * constant) / (dimension + constant * Math.abs(overshoot));
}
```

**The rest of the gesture contract:**
- **Respond on pointer-down, not on release** — waiting for `click` feels dead. Highlight on touch-down, commit on touch-up, cancel by dragging away. **Feedback is continuous during the interaction**, not just at the end.
- **Track 1:1 with the pointer, respecting the grab offset**: `const grabOffset = e.clientY - el.getBoundingClientRect().top`. Snapping the element's center to the finger breaks the illusion.
- **Use `setPointerCapture`** so the drag survives the pointer leaving the element, and **guard multi-touch** (`if (isDragging) return;` on press) — otherwise switching fingers mid-drag teleports the element.
- **Keep a short velocity history** from the last few `pointermove` events, not just the current point, and **add ~10px of hysteresis** before committing to a direction.
- **Detect all plausible gestures in parallel from the first move**, cancel the losers once intent is clear — final-state-only recognizers (`swipeleft`-style) throw away the continuous tracking feedback needs. And **minimize disambiguation delays** — double-tap detection delays every single tap; only pay that where double-tap genuinely exists.

## Blur, material, and crossfades

**Blur repairs crossfades** — without it, a crossfade shows two distinct objects overlapping; blur blends them so the eye reads one thing transforming. **Keep transition-time blur under 20px** — heavy blur is expensive, especially in Safari.

```css
.crossfading {
  filter: blur(2px);
  opacity: 0.7;
  transition: filter 200ms ease, opacity 200ms ease;
}
```

**Materialize, don't just fade:** for a glass surface, animate blur radius and scale together on enter and exit, so it reads as a real material arriving.

```css
.toolbar {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(20px) saturate(180%);
  border-top: 1px solid rgba(255, 255, 255, 0.4);  /* bright edge = light catching the material */
}
```

**Never stack a light translucent surface on another translucent surface** — legibility collapses. **Never use flat gray text over a translucent surface** — bump contrast, add a weight step and a touch of letter-spacing; put color on a solid layer. Material weight encodes hierarchy: heavier, darker materials separate structural regions, lighter ones mark interactive elements; bigger surfaces read as thicker (more blur, deeper shadow than a small chip). **Instead of a hard 1px divider under a sticky header**, use a scroll edge effect — a small blur or gradient mask where content meets floating chrome, only where floating UI actually overlaps content.

**The shadow shape that reads as a real surface** — an inset hairline ring in place of a border, plus a two-layer shadow. A solid border where a semi-transparent shadow belongs is one of the most common generated-UI tells:

```css
box-shadow:
  0 0 0 1px rgba(255, 255, 255, 0.08) inset,
  0 8px 24px rgba(0, 0, 0, 0.24),
  0 2px 6px rgba(0, 0, 0, 0.12);
```

## Accessibility

**Reduced motion means fewer and gentler animations, not zero.** Keep opacity and color transitions that aid comprehension; remove movement. A global `* { animation-duration: 0.01ms !important }` kill destroys useful feedback and is a bug, not compliance. In JS: `const reduce = useReducedMotion(); const closedX = reduce ? 0 : '-100%';`

```css
@media (prefers-reduced-motion: reduce) {
  .sheet { transition: opacity 200ms ease; transform: none !important; }
}
```

Two sibling queries deserve the same respect:

```css
@media (prefers-reduced-transparency: reduce) {
  .toolbar { background: white; backdrop-filter: none; }   /* frostier or solid */
}
@media (prefers-contrast: more) {
  .card { background: var(--surface-solid); border: 1px solid var(--ink); }
}
```

**Vestibular specifics:** avoid full-viewport moving backgrounds, slow looping oscillations near 0.2 Hz (one cycle per 5 seconds), and abrupt brightness jumps. Make large moving objects semi-transparent while they travel; fade big surfaces out during a large reposition and back in once settled.

**Gate hover motion on real pointers** — touch devices fire hover on tap:

```css
@media (hover: hover) and (pointer: fine) {
  .card:hover { transform: scale(1.02); }
}
```

## Performance traps

- **Framer Motion / Motion `x`, `y`, `scale` shorthand props are not hardware-accelerated** — they run through `requestAnimationFrame` on the main thread and drop frames under load. `animate={{ transform: "translateX(100px)" }}` composites; `animate={{ x: 100 }}` does not.
- **CSS animations beat JS under load** (off the main thread): CSS for predetermined motion, JS for dynamic, interruptible motion. The Web Animations API (`element.animate()`) gives JS control at CSS performance — hardware-accelerated, interruptible, no library.
- **Never drive a child transform by setting a CSS variable on the parent** — custom properties inherit, so one change recalculates styles for every descendant (a recalc storm in a drawer with many rows): `el.style.setProperty('--swipe', d + 'px')` recalcs every child; `el.style.transform = 'translateY(' + d + 'px)'` touches only this element.
- **Never mix GSAP or Three.js with a React animation library in the same component tree** — they fight over the same frames.
- **Never use `useState` for continuous values** (mouse position, scroll progress, drag distance) — use motion values, refs, or CSS variables scoped to the animated element. Never attach a raw `scroll` listener writing to React state; use `useScroll` or a scroll-driven animation timeline.
- `will-change: transform` is a targeted hint for known-expensive animations, not a baseline — overuse costs memory. Target 60fps (16ms per frame); 120fps on newer displays. Below 50, simplify rather than optimize.
- **Keep content visible in the default state**, revealed by animation rather than hidden by it — if the script fails, a page hidden at rest stays blank forever.

## Reviewing motion

Default to flagging; approval is earned. Something that "works" but feels sluggish, lands from the wrong origin, fires too often, or drops frames is a regression.

**Flag on sight:**
- `transition: all` · `scale(0)` · a pure opacity fade with no transform at all · `ease-in` on any UI interaction, or a weak built-in easing on a deliberate animation
- Animation on a keyboard shortcut, command palette, or 100+/day action · UI duration over 300ms with no stated reason
- `transform-origin: center` on a trigger-anchored popover, dropdown, or tooltip · keyframes on toasts, toggles, or anything triggered rapidly
- Animating `width`, `height`, `margin`, `padding`, `top`, `left` · motion library shorthand props (`x`, `y`, `scale`) on motion that runs while the page is busy · a CSS variable set on a parent to drive a child transform
- Missing `prefers-reduced-motion` handling on movement · ungated `:hover` motion
- Symmetric enter/exit timing on a press-and-hold interaction · everything entering at once where a 30–80ms stagger belongs

**Fix in this order** — prefer earlier moves; the cheapest and most valuable fixes are removals, and **when unsure whether motion feels right, the strongest move is usually to delete it**: 1 **Delete the animation** → 2 Reduce it → 3 Fix the easing → 4 Fix the origin and physicality → 5 Make it interruptible → 6 Move it to the compositor → 7 Make the timing asymmetric → 8 Polish (blur-masked crossfade, stagger, spring, `@starting-style`) → 9 Accessibility and cohesion.

**Report format** — one table, one row per finding. Not prose, not before/after on separate lines.

| Before | After | Why |
|---|---|---|
| `transition: all 300ms` | `transition: transform 200ms var(--ease-out)` | `all` animates unknown properties; 300ms reads as lag on a dropdown |

Then a verdict grouped by impact, highest tier first, empty tiers omitted: feel-breaking regressions · motion that should be deleted · performance · interruptibility and timing · origin, physicality, cohesion · accessibility.

**Verifying by feel** — motion can be mechanically correct and still feel wrong; look at it:
- **Slow it down** — durations × 3–5×, or 10% playback in the DevTools Animations panel. Watch for two states overlapping in a color transition, abrupt easing starts/stops, wrong origins, opacity/transform/color out of sync.
- **Spam the trigger** — open and close ten times fast; does it restart from zero?
- **Toggle `prefers-reduced-motion`** in the DevTools Rendering panel: movement gone, opacity feedback remains.
- **Test gestures on real hardware** (a simulator won't tell you whether a swipe feels right), and **look again the next day.**

## Cohesion

Motion carries personality and must agree with type and color: playful products can be bouncier, professional tools crisp and fast. A deliberately elegant component can run *slightly slower* than the house rule and use plain `ease` — Sonner's toasts do exactly that. That's a deviation you argue for in a sentence, not one you drift into. Some things have no formula (the right opacity/height blend on a collapsing element is trial and error); when you hit one, say so rather than inventing a rule.

## Generation checklist

*This is the builder's own list. It does not count as verification: the finish reviewer independently judges the rendered screenshots and its verdict is the only pass that matters.*

- [ ] Every animation passed the frequency gate. Nothing keyboard-initiated animates.
- [ ] Every animation has a named purpose from the list.
- [ ] Scroll-driven work has a storyboard in `work/storyboard.md`: no empty-viewport rows, overlap within half a viewport, scroll budget ≤1.5× the unpinned height with the arithmetic shown, every pinned hold and content beat named.
- [ ] UI durations under 300ms; Operate surfaces 150–250ms.
- [ ] No `ease-in` on UI. Custom curves used, not the CSS defaults.
- [ ] Entrances start from `scale(0.9)`–`scale(0.97)` with opacity. No `scale(0)`.
- [ ] Anchored surfaces scale from their trigger. Modals stay centered.
- [ ] Enter and exit follow the same path. Press-and-hold timing is asymmetric.
- [ ] Rapid-trigger UI uses transitions or springs, never keyframes.
- [ ] Only `transform` and `opacity` animate, or a documented exception.
- [ ] No motion-library shorthand props on load-time animation.
- [ ] No parent CSS variable driving a child transform.
- [ ] `prefers-reduced-motion` gives fewer and gentler motion, not zero.
- [ ] Hover motion gated on `(hover: hover) and (pointer: fine)`.
- [ ] Stagger 30–80ms, and it never blocks interaction.
- [ ] Content is visible at rest.
- [ ] Watched at 10% playback. Trigger spammed. Reduced-motion toggled.
