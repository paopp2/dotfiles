---
name: explain-diff
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Publishes the explanation as a Claude Artifact (HTML file on request).
---

# Explain Diff

Please make me a rich, interactive explanation of the specified code change.

It should have these sections:

- Background: Explain the existing system relevant to this change. (You should broadly explore surrounding code for this.) We don't know how much the reader already knows, so include a deep background for beginners (note that it can be skipped if the reader is already familiar), and then a more narrow background directly relevant to the change.
- Intuition: Explain the core intuition for the code change. The focus here is to explain the essence, not the full details. Use concrete examples with toy data. Use figures and diagrams liberally.
- Code: Do a high-level walkthrough of the changes to the code. Group/order the changes in an understandable way.
- Quiz: Come up with five questions that test the reader's knowledge of this PR. This should be medium difficulty, difficult enough that you actually need to understand the substance of the PR to answer them, but not gotchas. The goal is to help the reader make sure that they've actually understood. These should be presented as interactive multiple-choice questions, and when the user clicks, it tells them whether they were correct and gives feedback.

Output (default: Claude Artifact):

- Load the `artifact-design` skill first, then author the page as a single self-contained HTML file (inline CSS and JavaScript, no external assets) and publish it with the `Artifact` tool. Write the file to your scratchpad directory, named `{YYYY-MM-DD}-explanation-{slug}.html`; the date prefix keeps files time-sorted and out of version control. If the caller (e.g. `/create-pr`) specifies a different path, use that instead.
- Artifact metadata: `<title>` is a short name for the change (two to four words, no summary). Pass a one-sentence `description` and a stable `favicon` (default `📖`). Set `label` to a few-word version name.
- The Artifact tool wraps the file in `<!doctype html>...<body>` at publish time, so write the page content directly: no `<!DOCTYPE>`, `<html>`, `<head>`, or `<body>` tags of your own. Put `<title>` at the top of the file.
- Theme-aware: define the light palette as tokens on `:root`, override under `@media (prefers-color-scheme: dark)` guarded as `:root:not([data-theme="light"])`, and again under `:root[data-theme="dark"]`. Give `body` an explicit token background.
- Once published, open the artifact URL in my default browser with `open <artifact-url>`, and print the URL in the reply. Artifacts start private; remind me to share it if others need it.
- Re-publishing: to revise, edit the same file and call `Artifact` with the same path so it redeploys to the same URL.
- HTML-file fallback: only when the `Artifact` tool is unavailable or I explicitly ask for a file, write the same HTML (with its own `<!DOCTYPE html>` skeleton) to a global place outside the repo, e.g. `/tmp/2026-01-12-explanation-<slug>.html`, and open it with `open <path-to-file>`.

Format:

- Make the whole thing one long page with section headers and a table of contents. Don't use tabs for the top-level structure. Basic responsive styling so you can view it on a phone is nice too; wide content (tables, diagrams, code blocks) scrolls inside its own `overflow-x: auto` container.
- Please write with the clarity and flow of Martin Kleppmann, making it engaging and written in classic style. Transitions between sections should be smooth.
- Some tips on diagrams. Ideally, you should pick a small number of diagram families that can be reused throughout the explanation to explain various cases. Some useful kinds of diagrams:
  - A very simplified version of the UI that the user sees in the app, to explain UI changes.
  - A system diagram showing data flow or communication between components. Make sure to include example data here!
- Don't use ASCII diagrams. Always use simple HTML designs for your diagrams, HTML lists for lists of things, etc.
  - For code blocks, always use `<pre>` tags. If you use a custom styled div instead, it **must** have
    `white-space: pre-wrap` in its CSS, or the browser will collapse all newlines into a single line.
    Before publishing, scan each code block in the HTML source and confirm its CSS includes
    `white-space: pre` or `pre-wrap`.
- Use callouts for key concepts or definitions, important edge cases, etc.
