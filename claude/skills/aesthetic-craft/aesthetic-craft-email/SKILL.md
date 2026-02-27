---
name: aesthetic-craft-email
description: Email template design intelligence. Use alongside the core aesthetic-craft skill when creating HTML email templates, email campaigns, newsletters, transactional emails, or any email-rendered content. Covers HTML email constraints, rendering quirks, email-specific layout techniques, subject line and preheader craft, and the unique design challenges of inbox-rendered content.
---

# Aesthetic Craft — Email

**Prerequisites**: Always read `aesthetic-craft/SKILL.md` (core) first. This sub-skill adds email-specific guidance.

---

## The Email Design Mindset

Email design is a discipline of **constraints**. The inbox is hostile territory — every email client renders HTML differently, most modern CSS doesn't work, and your audience decides in 2-3 seconds whether to read or delete. Great email design isn't about what you can add. It's about communicating clearly despite severe limitations.

**Three realities:**

1. **The preview pane is everything.** Most people see only the top 300-500px (and often only 100px in mobile previews). Your most important content goes there — not below the fold.
2. **Every email competes with 50 others.** Clarity and scannability beat visual complexity. The reader is triaging, not browsing.
3. **Rendering is broken by design.** Outlook uses Word's HTML engine. Gmail strips `<style>` tags. Dark mode inverts your colors unpredictably. Design defensively.

---

## The Inbox First: Subject Lines and Preheaders

The most impactful "design" decisions in email happen before the email is opened. The subject line and preheader determine whether your carefully designed email ever gets seen at all. Treat them as the storefront — the body is the interior.

### Subject Line Craft

**The job of the subject line**: Get the email opened. That's it. It's not a summary. It's not a headline. It's a door that needs to be interesting enough to walk through.

**Length**: 30-50 characters is the sweet spot. Mobile inboxes truncate around 35-40 characters. Front-load the most compelling words — don't bury the hook at the end.

**What works:**
- **Specificity** beats vagueness. "Your report is ready" > "Important update inside"
- **Curiosity gaps** — imply value without revealing everything. "The one metric we got wrong" > "Monthly metrics report"
- **Numbers and specifics** — "3 things to try this week" > "Tips for you"
- **Lowercase or sentence case** — feels human. ALL CAPS and Title Case On Every Word feel like marketing.
- **Questions** — "Still thinking about it?" > "Don't forget!"
- **Name when earned** — personalization works when relevant ("Alex, your project shipped"), feels creepy when forced ("Alex, check out these deals")

**What to avoid:**
- Spam trigger words in excess: FREE, ACT NOW, LIMITED TIME, CLICK HERE, $$$ — one is fine in context, stacking them flags filters
- Misleading subjects that don't match content — destroys trust permanently
- Emoji overload — one emoji can work (✅, 📊), three is a carnival
- Clickbait without payoff — the body must deliver what the subject promised
- RE: or FWD: faked — manipulative and instantly recognized

**Subject lines by email type:**

| Email type | Good subject line approach | Example |
|---|---|---|
| Welcome / onboarding | Warm, simple, sets expectations | "You're in — here's your first step" |
| Transactional | Clear, functional, scannable | "Your receipt from March 15 ($42.00)" |
| Newsletter | Specific lead story, not generic label | "Why our signup flow was losing 40% of users" |
| Marketing / promotional | Benefit-first, specific offer | "New templates for pitch decks" |
| Re-engagement | Honest, low-pressure | "Still interested? No hard feelings either way." |
| Event | Date + value, not just announcement | "March 20: The workshop 200 people waitlisted for" |

### Preheader Text

The preheader is the gray text that appears after the subject line in most email clients. It's your second line of persuasion.

**What it does**: Extends the subject line. Provides context. Answers "why should I open this?"

**How to set it**: Add invisible text at the very top of the email body. If you don't set it, email clients pull the first visible text — which is often "View in browser" or an alt tag. Control this.

```html
<div style="display:none; max-height:0; overflow:hidden; font-size:0; line-height:0;">
  Your preheader text goes here. Keep it under 100 characters for best display.
</div>
```

**Preheader strategy:**
- **Complement, don't repeat**: If the subject is "Your weekly report is ready," the preheader shouldn't be "Weekly report now available." Try: "Revenue up 12% — one metric needs attention."
- **Length**: 40-100 characters. Too short and the email client backfills with body text. Too long and it gets cut.
- **Fill the space**: After your preheader text, add non-breaking spaces (`&nbsp;`) or zero-width characters to prevent the email client from pulling in body text after your preheader.

### The Subject + Preheader Pair

Think of them as a unit — one-two punch:

| Subject | Preheader |
|---|---|
| "Your workspace is ready" | "One thing to try first before anything else." |
| "March metrics: the good and the bad" | "Revenue hit a record. Churn did too." |
| "We made a mistake" | "Here's what happened and what we're doing about it." |
| "3 new features you asked for" | "Batch export, dark mode, and the big one." |

---

## HTML Email Technical Constraints

These aren't guidelines — they're hard walls. Breaking them means broken emails in real inboxes.

### What Works

- **Tables for layout**: Yes, tables. `<table>`, `<tr>`, `<td>`. This is the only reliable cross-client layout method. Flexbox and CSS Grid do NOT work in Outlook.
- **Inline styles**: Put CSS directly on elements via `style=""`. Many email clients strip `<style>` blocks from `<head>`.
- **Basic CSS properties**: `color`, `font-size`, `font-family`, `font-weight`, `background-color`, `padding`, `margin`, `border`, `text-align`, `line-height`, `width`, `max-width`.
- **Web-safe fonts + fallbacks**: Arial, Helvetica, Georgia, Times New Roman, Verdana, Trebuchet MS, Courier. Use web fonts only with proper fallbacks — they won't render in Outlook, many Gmail versions, or most mobile clients.
- **Images with alt text**: Always provide `alt=""` for decorative images and descriptive alt text for content images. Many clients block images by default.
- **`max-width` on wrapper**: Use a `max-width: 600px` (standard) or `max-width: 640-700px` (modern) wrapper for the email body. Center it with `margin: 0 auto`.

### What Doesn't Work

- **Flexbox / CSS Grid**: Not supported in Outlook (which uses Word's renderer). Falls apart in many clients.
- **`position: absolute/relative`**: Inconsistent. Avoid.
- **`float`**: Partially works but causes rendering bugs. Use table cells instead.
- **CSS animations / transitions**: Won't render in most clients. Some Apple Mail / iOS support exists but it's unreliable.
- **`<div>` for layout**: Unreliable without inline-block hacks. Use tables.
- **External stylesheets**: Stripped by most clients.
- **JavaScript**: Completely blocked. Always.
- **Video / audio embeds**: Not supported except as linked thumbnails.
- **`margin` on images in Outlook**: Outlook ignores image margins. Use padding on the parent `<td>` instead.
- **Background images (Outlook)**: Need VML fallback code for Outlook. Without it, the background just won't appear.

### The Dark Mode Problem

Many email clients now force dark mode. Your design needs to survive it:

- **Test in dark mode**: Light backgrounds become dark. Dark text becomes light. Your carefully chosen colors may invert.
- **Use `color-scheme: light dark` meta tag** where supported.
- **Avoid pure white (#FFFFFF) backgrounds**: Use slightly off-white (#F7F7F7, #FAFAFA). Pure white inverts to pure black in some dark modes, creating harsh contrast.
- **Avoid pure black (#000000) text**: Use near-black (#1A1A1A, #222222). Same reason — pure values invert aggressively.
- **Test images on dark backgrounds**: Logos with transparent backgrounds may become invisible on dark.
- **Provide dark-compatible logo variants** when possible, or add a subtle background shape behind logos.

---

## Email Design Patterns

### Layout

- **Single column is king**: One column, 600px max, stacked blocks. The most reliable and readable layout across all clients and screen sizes. Multi-column layouts break on mobile and in narrow preview panes.
- **Two-column for simple grids**: If you need two columns, use a table with two `<td>` cells. For mobile, consider stacking (some clients support `display: block` on table cells, but test thoroughly).
- **Modular blocks**: Think in self-contained blocks — hero, text section, CTA, image, divider, footer. Each block is its own table row. Reorder, add, or remove blocks without breaking the layout.
- **Padding, not margin**: Use `padding` on `<td>` elements for spacing. `margin` is unreliable across clients.

### The Inverted Pyramid

The most effective email structure for action-driven emails:

1. **Attention** (top): Bold headline or hero image. What is this about?
2. **Anticipation** (middle): Brief supporting text. Why should I care?
3. **Action** (bottom): Single, clear CTA button. What do I do?

The visual shape narrows from wide (image/headline) → medium (text) → narrow (button), funneling the eye to the action.

### CTA Buttons

Buttons must be:
- **Bulletproof**: Built with HTML/CSS, not images. `<a>` tag with inline styles, padded `<td>`, or VML buttons for Outlook. If the image doesn't load, the button still works.
- **Large enough to tap**: 44px minimum height. 200-300px wide on mobile. Full-width on very small screens.
- **High contrast**: The button must be the most visually prominent element.
- **Singular**: One primary CTA per email. If you have secondary actions, make them visually subordinate (text links, not buttons).
- **Action-oriented copy**: "Get Your Report" > "Click Here." "Start Free Trial" > "Submit." The button text IS the value proposition.

### Images

- **Assume images will be blocked**: Design the email to make sense with images off. Every image needs alt text. Don't put critical info only in images.
- **Retina-ready**: Serve images at 2x display size (e.g., a 600px-wide image is actually 1200px) for sharp rendering on high-DPI screens. Set the display size with `width` attribute.
- **File size matters**: Compress aggressively. Total email size (with images) should ideally be under 100KB for fast loading. Large emails get clipped by Gmail (>102KB of HTML).
- **Format**: PNG for graphics/logos with transparency. JPEG for photos. GIF for simple animations (supported in most clients except Outlook, which shows the first frame).

### Typography

- **System font stacks**: `font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;`
- **Web fonts as enhancement**: Use `@import` or `<link>` for web fonts, with the system stack as fallback. Expect most recipients to see the fallback.
- **Size minimum**: 14px body (16px preferred on mobile). 22px+ for headlines.
- **Line height**: 1.5-1.6 for body. 1.2-1.3 for headlines.
- **Link styling**: Underline links. Don't rely on color alone — some clients override link colors.

---

## Email Types and Their Design Needs

| Email Type | Complexity Budget | Key Focus |
|---|---|---|
| Transactional (receipts, confirmations, password resets) | Very low | Clarity, trust, scannability. No decoration. The info IS the design. |
| Onboarding / welcome | Medium | Warmth, one clear next action, brand personality |
| Newsletter | Medium | Scannable sections, clear hierarchy, easy to skim |
| Marketing / promotional | Medium-High | One compelling offer, strong visual, single CTA |
| Event invitation | Medium | Date/time/place immediately visible. Easy RSVP action. |
| Re-engagement / win-back | Medium | Emotional hook, compelling reason to return, clear CTA |
| Digest / roundup | Low-Medium | Consistent repeating blocks, easy scanning, no clutter |

---

## Email AI Anti-Patterns

| AI Pattern | What to Do Instead |
|---|---|
| Complex multi-column layouts | Single column. It works everywhere. |
| Flexbox / CSS Grid in email | Tables with inline styles |
| Image-only emails | HTML text with supporting images |
| Tiny CTA buttons | Large, padded, high-contrast bulletproof buttons |
| Multiple competing CTAs | One primary action. Secondary actions as text links. |
| Pure white backgrounds / pure black text | Off-white (#F7F7F7) and near-black (#222) for dark mode survival |
| Hero image with text baked in | Live text over simple background. Works when images are blocked. |
| Assuming fonts will render | System font stacks with web fonts as progressive enhancement |
| Ignoring Gmail clipping | Keep HTML under 102KB. Test in Gmail. |
| Dense paragraphs of text | Short paragraphs (2-3 sentences). Use headers to break sections. Scannable. |
| Generic subject lines ("Your monthly update") | Specific, benefit-driven subject lines with complementary preheader |
| No preheader set | Email client pulls "View in browser" or alt text. Always set the preheader explicitly. |

---

## Email Accessibility

- **Semantic structure**: Use heading tags within the email body. `<h1>` for the main message, `<h2>` for section breaks.
- **Alt text on all images**: Descriptive for content, empty (`alt=""`) for decorative.
- **`role="presentation"` on layout tables**: Screen readers should not announce table structure for layout tables.
- **Sufficient contrast**: 4.5:1 for body text, 3:1 for large text. Test in both light and dark mode.
- **Link text**: "Read the full report" > "Click here." Descriptive link text helps screen readers.
- **Language attribute**: `<html lang="en">` (or appropriate language).
- **Logical reading order**: The source order of the HTML should match the visual reading order.

---

## Email Testing Checklist

Before sending, verify:
- [ ] Subject line under 50 characters, front-loaded with the hook
- [ ] Preheader text set explicitly (not defaulting to body text)
- [ ] Subject + preheader work as a complementary pair
- [ ] Renders in Gmail (web + mobile)
- [ ] Renders in Outlook (2016+ and Office 365)
- [ ] Renders in Apple Mail
- [ ] Renders with images off (alt text visible, CTA still clear)
- [ ] Dark mode test (do colors invert gracefully?)
- [ ] HTML under 102KB (Gmail clipping check)
- [ ] All links work
- [ ] CTA buttons are bulletproof (not image-based)
- [ ] Mobile rendering (single column, readable text, tappable buttons)
- [ ] Unsubscribe link is present and visible

---

## Working Process for Email

1. **Define the type**: What kind of email? Transactional, marketing, newsletter? This sets the complexity budget.
2. **Write the subject line and preheader first**: This is the most impactful design decision. If the email never gets opened, nothing else matters. Write 3-5 subject line options. Pick the most specific, most human one.
3. **Write the body**: Email is a writing medium. Draft the message, the headline, the CTA — then design around it.
4. **Build with tables**: Single-column layout, modular blocks, inline styles, system fonts.
5. **Design for failure**: Images blocked. Dark mode inverted. Fonts missing. Gmail clipped. The email must survive all of these.
6. **Critique**: Run the core critique engine with email-specific checks: Does it work without images? Is the CTA obvious? Would I scan or skip this in my own inbox? Is it under 102KB? Does the subject line + preheader pair earn the open?
7. **Deliver**: Share Design Rationale with email-specific note on rendering compromises made and subject line strategy.
