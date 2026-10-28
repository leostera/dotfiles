---
name: 3blue1brown-explainer-video
description: Plan, script, storyboard, and build original visual explainer videos with intuition-first teaching, evolving diagrams, and clear technical storytelling. Use for math, software, databases, infrastructure, and other technical videos, especially Remotion projects or when a 3Blue1Brown-like explanatory approach is requested.
---

# Visual explainer videos

Create videos that help viewers form a correct mental model, not just remember a list of facts. Use the teaching approach associated with 3Blue1Brown—intuition first, ideas revealed through coherent animation, and visual continuity—as inspiration. Make original visuals and narration: do not copy a creator's exact frames, signature assets, logo, music, branding, or voice, and do not imply affiliation.

## Start with the viewer

Before scripting, establish:

- Who the viewer is and what they should understand or be able to do afterward.
- The central question the video answers.
- The target runtime, format, and any supplied visual references.
- Which product behavior and technical claims are verified in the current repository or authoritative docs.

For a developer-facing database explainer, make the audience and category explicit immediately: say that it is a **database developers build software with**. Explain it from the developer's point of view, not as a generic platform or architecture tour. Cover, as appropriate:

1. What the developer stores and what the database promises.
2. What using it looks like: a realistic request, API/SDK example, and resulting behavior.
3. Why and when to choose it, and when not to.
4. The internal mechanism that makes the user-visible behavior work.
5. How it is deployed and runs on its hosting platform, including relevant limits and tradeoffs.
6. Practical usage guidance and a clear takeaway.

Verify API names, consistency, durability, sharding, limits, and deployment details against code, tests, RFDs, or current platform documentation. Distinguish shipped behavior from plans. Never invent a convenient feature or hide a meaningful limitation. Use only information appropriate for the intended audience; do not put internal-only endpoints, private service topology, credentials, or employee-only details in narration, source files, or bundled resources.

## Build the explanation

1. Choose one concrete example or running scenario and carry it through the video.
2. Organize the story as a sequence of questions. Each scene should answer one question and create a reason to watch the next.
3. Begin with a familiar problem or observation. Introduce terminology only when it becomes useful.
4. Reveal the mental model in steps: show a concrete situation, animate what changes, name the concept, then connect it to code or implementation details.
5. Use analogy as a bridge, not as proof. State where it stops matching reality.
6. Balance intuition with actionable specifics. For developer videos, show short, real code at the moment it explains an operation; do not turn the whole video into slides of text or code.
7. Make tradeoffs part of the explanation. Include failure cases, limits, operational boundaries, or reasons not to use the system where they affect the viewer's choice.

For every scene, define its purpose before implementation:

- **Viewer question:** what is the audience wondering now?
- **Narration:** what should they understand by the end?
- **Visual action:** what changes on screen to make that idea visible?
- **Evidence or caveat:** what implementation detail supports the claim, or what boundary must be shown?
- **Transition:** how does this visual or idea lead to the next scene?

Respect the project's existing script format when one exists. Estimate spoken duration from the actual narration (roughly 125–145 words per minute is a starting point, not a guarantee); account for pauses, then validate against generated audio rather than assuming text length equals runtime.

## Visual language

Read `references/styleguide.md` before storyboarding or designing visuals. Treat it as an adaptable default, not a rigid template.

Prefer a small number of meaningful, evolving diagrams over dashboards, decorative cards, or unrelated scene changes. Use transformations to expose relationships: a record becomes a log entry, a query follows a path, a local object receives a request, or one state turns into another. Keep objects spatially consistent when the viewer benefits from continuity. Make cause and effect visible.

Favor legible composition, negative space, restrained color, a clear type hierarchy, and deliberate motion. Use labels, arrows, axes, code, particles, shapes, timelines, or diagrams only when they carry meaning. A dark canvas, elegant typography, thin lines, and syntax color can be a useful starting point, not a mandatory template. If a reference is supplied, extract broad qualities such as pacing, contrast, or diagram density and create a distinct visual treatment rather than tracing it.

Avoid visual metaphors that imply false architecture. In database videos, make boundaries between client, network, Worker/runtime, Durable Object, storage, and derived indexes explicit when they matter. Do not depict a projection or cache as the source of truth if it is not one.

## Remotion implementation

When building in an existing project:

- Inspect its README, package scripts, composition entry point, existing scene components, and assets before changing the structure.
- Keep scene timing and transitions explicit. Derive animation from the frame (`useCurrentFrame`, `interpolate`, `spring`, or equivalent) so renders are deterministic; avoid timers and unseeded randomness.
- Prefer reusable scene components and crisp vector/SVG diagrams for geometry. Keep text within safe margins and check it at the final resolution.
- Integrate voice-over only when requested. Use the project's configured or user-authorized speech service; keep credentials out of source and logs. If synthesis is unavailable, render a clearly identified silent preview instead of pretending audio exists.
- Run the project's typecheck and render a preview. Inspect representative frames and the complete video/audio metadata; check duration, resolution, frame rate, legibility, clipping, sync, and factual consistency. Listen to the narration when possible and adjust timing or wording if it feels rushed.
- Use the bundled helpers when useful: `scripts/narration-report.mjs` estimates per-scene and total speech timing from a JSON script; `scripts/fit-audio-duration.mjs` fits an audio file to a target WAV duration with pitch-preserving `ffmpeg atempo` and rejects large speed changes; `scripts/check-video.mjs` reports streams and can verify expected duration or audio presence. Pass project file paths relative to the current working directory. The audio and video helpers require `ffmpeg` and `ffprobe`; no Cloudflare-internal service or credential is needed.

Do not expand a script-only request into a full video render unless asked. Report the files created, validation performed, and any unresolved credential, rendering, or factual blocker.