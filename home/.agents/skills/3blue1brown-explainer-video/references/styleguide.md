# Visual style guide

Use this as the default look and feel for videos created with this skill. It is a flexible direction, not a template: adapt it to the subject, supplied references, accessibility needs, and the user's preferences. Aim for the clarity and visual reasoning of a good mathematical explainer while creating original artwork and motion.

## Intent

The image should feel thoughtful, precise, calm, and alive. The viewer should feel that an idea is being uncovered—not that a product deck is being presented. Every visual element should either explain, orient, or provide deliberate rest.

For a software or database explainer, dramatize the system's behavior with a small number of clear objects and transformations. Prefer a request moving through a real boundary, a fact being added, or a query following a relationship over generic product UI mockups.

## Composition and palette

- Default to a 16:9 frame with a deep charcoal or near-black background. Use pure black only when it supports the chosen reference.
- Preserve generous negative space. Give each scene one visual center of gravity; don't fill the frame just because it is empty.
- Use warm white for primary text and diagrams, cool muted gray for secondary information, and a restrained set of semantic accents. Example palette: ice blue for an active path, amber for evidence or a write, muted green for a confirmed result, and restrained red for a failure or limit.
- Keep semantic colors consistent. Do not use color as the only means of conveying meaning; pair it with position, shape, or labels.
- Keep important content inside comfortable safe margins and large enough to read at the final delivery resolution.

## Typography and code

- Use a graceful serif face, including italic emphasis, for occasional chapter titles or key phrases. Keep titles short and give them room.
- Use a clean sans serif for labels and explanatory text. Use monospaced type only for code, identifiers, and data that benefit from it.
- Treat syntax color as a small accent, not a rainbow. Show only the lines needed to make the point, and emphasize the exact line or token currently being narrated.
- Avoid long paragraphs, tiny annotations, dense legends, fake browser chrome, and persistent UI that makes the piece feel like a dashboard.

## Diagrams and motion

- Build diagrams from a few crisp primitives: points, thin lines, arrows, paths, boundaries, grids, timelines, or simple shapes. Keep line weights and label placement consistent.
- Animate relationships rather than decoration. Draw a connection when it becomes relevant; move an object when the system's behavior changes; transform one representation into another when explaining how the two relate.
- Keep spatial continuity when it helps the viewer track identity or causality. When a visual metaphor is replaced, make the transition legible rather than abruptly changing the rules.
- Use restrained easing and confident holds. Motion should clarify, not compete with narration. Avoid constant motion, excessive bounce, rapid zooms, and particles without explanatory meaning.
- Let important changes breathe. A brief still moment can make an idea easier to absorb than another transition.

## Story-to-image rules

- Pick one concrete running example and let it recur. Use it to connect user action, data, internal behavior, and the result.
- Let the audience see cause and effect: request → boundary → operation → observable result. Make which parts are real system components explicit.
- Add labels at the moment they become useful. Prefer direct labels on objects over a detached legend.
- Keep analogies visually distinct from literal architecture. Name the handoff back to the real implementation so viewers don't mistake the metaphor for a guarantee.
- Show constraints visually when they matter: limits, retries, partial failure, consistency boundaries, or non-scalable components should be legible—not hidden in fine print.
- In database explainers, distinguish durable source-of-truth data from indexes, caches, projections, and other rebuildable views.

## Voice and pacing

Pair the image with a curious, direct, measured narration. Prefer plain language and concrete verbs. Introduce technical terms after the intuition they name. Do not imitate a specific creator's voice or use branded catchphrases.

Avoid treating every sentence as a cue for a cut. Let a visual continue while the narration explains it, and use transitions when the idea itself changes. Plan text density and animation speed for comprehension at normal playback speed.

## Avoid

- Generic dashboard layouts, rows of floating cards, decorative charts, and unrelated stock footage.
- A wall of code, overlong on-screen prose, tiny labels, or color-only distinctions.
- Visual metaphors that imply unsupported product behavior or hide an architectural boundary.
- Effects that are fashionable but uninformative: perpetual parallax, arbitrary particles, strobing, or constant camera movement.
- Copying a reference video's exact composition, illustrations, logo, signature motifs, typography, music, or branding. Extract broad principles and make new visuals.

## Final frame check

Before accepting a scene or render, ask:

1. Can a viewer describe the one idea this image is teaching?
2. Does the motion reveal a relationship or state change?
3. Are labels readable at delivery size and visible long enough?
4. Are color and visual metaphors consistent and technically honest?
5. Is there enough negative space for the image to feel intentional?
6. Would the scene still make sense to a developer who has never seen the product's UI?
