---
name: leo-product-design
description: Shape product UX, UI, copy, and developer experience the way @leostera would. Make interfaces dense, keyboard-first, instant, and stable, steal from proven apps, keep information architecture and URLs clean, lead copy with user value, and make CLIs and dev tools feel fast and legible. Use when designing, reviewing, or polishing apps, dashboards, mobile screens, websites, CLIs, or developer tools.
---

# Leo Product Design

Use this skill to shape a product the way @leostera would, without needing him in the room. It covers how the product should feel, how it's organised, what it says, and how tools for developers should behave. Use it with the impeccable skill for visual design work, and with leo-system-design for what sits behind the interface.

The person you work with owns the decisions. Bring these instincts as suggestions with reasons, and when they disagree, go with them and record the choice.

## 1. How it should feel

- **Dense, but readable.** People will have lots of items, so the UI should be compact and information-dense with no wasted space. "Too much padding" and "too little padding" are both bugs. Aim for a little air around text, and nothing more.
- **Full-bleed.** The main surface takes the whole window or screen. Remove chrome that doesn't earn its place: title bars on every pane, top bars that repeat the app name, mock window frames in a browser, margins above and below on a phone.
- **Keyboard-first.** Every frequent action has a shortcut that matches the platform's conventions. After any action, focus lands where the user will type next, with no extra click.
- **Instant and steady.** Actions update the state on screen synchronously. Nothing jiggles, shrinks, or reflows while data arrives. Open screens fast with the most recent content first, and make the rest available, such as full scrollback, without blocking.
- **Predictable.** Navigation order matches display order. Closing something returns focus to the previous item in the same group, deterministically. Lists keep stable orders: groups sorted by name, items within a group by recency.
- **Quiet.** Hide what's stale behind "Show older" rather than deleting it. Don't show transient or confusing errors that resolve by themselves. Don't let text inside canvases get selected by accident when dragging.
- **Native where it counts.** On each platform, use its own conventions for menus, gestures, and shortcuts. Native look matters less than the feel.

> *Ask:* "Where is space wasted? What would a keyboard user press here? Does anything move that shouldn't?"

## 2. Steal from products that got it right

- When an existing app already does something well, such as a terminal's splits, a messenger's sidebar, or a chat app's message layout, study its source or behaviour and match it closely. Look for open-source clones of the experience you want, and learn their layout techniques.
- Bring back good interactions from your own earlier versions instead of reinventing them worse. Recover them from version control if needed.
- Reuse libraries for solved problems such as fuzzy search, command palettes, and syntax highlighting.

> *Ask:* "Which app does this best? What exactly do they do, and why are we different?"

## 3. Information architecture

- **Put the domain hierarchy up front.** Navigation should mirror the real entities and how they nest, such as "Scenario > Run > Trajectory" or "Workspace > Session > Pane". When the model changes, restructure the navigation to match, with a clean cutover and no redirects for old routes while there are no users.
- **Use real URLs.** Use path-based routes, not hash routes, with readable segments. Keep shareable state in the URL, parsed with a schema and safe defaults, and keep transient state such as playback time in a separate parameter. A link should reproduce what the sender saw.
- **Make the whole thing clickable.** Rows and cards are links; don't add a "View" button next to them. Clicking anywhere on a step activates it.
- **Let people drill down.** Every reference (a function, a file, an entity) opens in place so it can be inspected without leaving the context.
- **Lead with meaning.** Show the name people care about first and its location second, such as `Class.method` before the file path.
- **Status with action.** Settings and status pages put the state at the top ("Connected for 30 minutes") with the one relevant action next to it ("Connect"). Show detected facts rather than asking for them, and remove fields users shouldn't need to set.
- **Make summaries scannable.** Scoreboards use colour (green, yellow, red) and answer the question people have, such as "best setup for each task", rather than dumping the full matrix.

> *Ask:* "Does the navigation match the domain? Can I share a link to exactly this? Can I click it?"

## 4. Interaction details

- **Confirm only what's destructive,** and say what will be lost: "This shell is still running a command", "These uncommitted changes will be discarded".
- **Keep invariants visible.** If the product promises something, such as always having at least one open session, the UI never violates it, even when the user closes everything.
- **Make gestures intentional.** Separate swipes from taps so moving between layers doesn't open things by accident. On mobile, define the stack of layers explicitly and make each gesture move exactly one layer.
- **Batch feedback.** When users review something, let them annotate inline and then send all comments at once. The main button reads "Approve" until there's a comment, then "Send feedback".
- **Recover with one click, then automate it.** When something breaks, such as a lost connection or a crashed process, offer a visible restart. If it keeps happening, add a setting that restarts it automatically.
- **Make configuration complete.** When a command or shell is configurable, the user types the full command that will run, with sensible defaults from their own environment.

## 5. Words

- **Lead with user value.** READMEs, landing pages, and product copy say what the user gets, not how it works inside. Introduce the concept first ("a graph database for the edge, fully managed, scales as you scale"), then how to use it. Internals belong in RFDs.
- **Explain it in one or two sentences.** If you can't say why someone wants it that briefly, the positioning isn't done.
- **Don't expose internals in the UI.** Don't name the underlying engine, model, or vendor when the user doesn't need to know it.
- **Have a voice.** Whimsy is welcome where it fits: a playful tagline, a characterful logo font, a small animation. Keep it out of the way of work.
- **Sound human.** Rewrite copy that reads robotic. Prefer value-oriented, plain sentences.
- **Show, with evidence.** Use charts from real benchmarks, methodology written like a short paper, and tables with the columns people compare, such as time, tokens, and cost.

## 6. Developer tools and CLIs

- **Show progress like a build.** Each step gets a line with a status mark, a count, and timing, for example `✓ Uploading 3 new · 1 cached 2.7s`. Verbose mode lists every item checked, with OK or an error, plus a total time. Mark cached results in dim text.
- **Be fast by default.** Cache results by content hash. Dev commands skip production bundling and start instantly, using standard tools such as the existing dev server rather than a custom one.
- **Don't fail on solvable problems.** When a port is busy, use the next free one. When results are missing, offer to produce them.
- **Use clear, conventional commands,** such as `dev`, `build`, `run`, `share`, `upgrade`, and `tidy`. Don't add aliases or wrapper scripts that hide the real command.
- **Make errors actionable.** Say what happened, why, and the exact next step.
- **Ship upgrades for breaking changes:** an `upgrade` command that migrates old data, and a migration guide.
- **Stay runtime-agnostic** where you can: hooks as plain functions, no lock-in to one JS runtime.

## 7. Process

1. **Offer alternatives.** For a new screen or a redesign, show two or three directions using the impeccable skill before committing to one.
2. **Look at it yourself.** Run the app and take screenshots, iterating until it matches the bar here, before asking the user to check. Read the screenshots and errors the user sends in full.
3. **Test what users do.** Write end-to-end UI tests that drive the real app the way a user does: shortcuts, focus, restarts, restored state. Use a self-test mode or visual snapshots where it helps, and add a test for every UX bug that gets fixed.
4. **Dogfood.** Use the product daily, and read the sessions and feedback of other people using it. Turn whatever trips them up into fixes.
5. **Polish in passes.** Make it work, then do focused passes on density, focus, motion, and copy. Fix small bugs as they're found.

## Checklist

- Is the UI dense but readable, full-bleed, and free of chrome that doesn't earn its place?
- Does every frequent action have a shortcut, and does focus land where the user types next?
- Do actions update instantly, without layout shifts or jiggles?
- Are orders stable, and do navigation and focus behave predictably?
- Did we study and match the app that does this best?
- Does navigation mirror the domain hierarchy, with real, shareable URLs?
- Are rows clickable, references drillable, and names shown before locations?
- Are destructive actions confirmed, saying what will be lost, and do the UI invariants hold?
- Does the copy lead with user value, hide internals, and sound human?
- Do CLIs show progress, cache, avoid needless failures, and give actionable errors?
- Were alternatives shown, screenshots checked, and UI behaviour covered by end-to-end tests?
