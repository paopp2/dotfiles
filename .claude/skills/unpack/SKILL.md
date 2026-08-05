---
name: unpack
description: Use when the user asks for a rich explanation of anything technical. Triggers on "explain", "how does X work", "walk me through", "what does this do", "teach me", "break down", or /unpack. Subjects include code, diffs, branches, PRs, modules, concepts, architectures, and algorithms. Produces HTML output.
---

# Unpack

> **GLOBAL SKILL**. User-level version. A project-level version may also exist. When this skill loads, announce to the user: "Running global version of unpack."

Please make me a rich, interactive explanation of the specified subject.

Resolving the subject from `$ARGUMENTS`: a file or directory path (read it), a function/class/symbol name (locate it with grep), a diff/branch/PR reference (diff it), a plain technical concept (no files needed), or empty (use the most recent code or topic in the conversation).

It should have these sections:

- Background: Explain the existing system or context relevant to the subject. (When the subject lives in a codebase, broadly explore surrounding code for this.) We don't know how much the reader already knows, so include a deep background for beginners (note that it can be skipped if the reader is already familiar), and then a more narrow background directly relevant to the subject.
- Intuition: Explain the core intuition for the subject. The focus here is to explain the essence, not the full details. Use concrete examples with toy data. Use figures and diagrams liberally.
- Code (only when the subject involves actual code): Do a high-level walkthrough of the code or change. Group/order it in an understandable way. Highlight what is important, summarize what is incidental.
- Quiz: Come up with five questions that test the reader's knowledge of the subject. This should be medium difficulty, difficult enough that you actually need to understand the substance to answer them, but not gotchas. The goal is to help the reader make sure that they've actually understood. These should be presented as interactive multiple-choice questions, and when the user clicks, it tells them whether they were correct and gives feedback.

Format:

- Output a single self-contained HTML file which includes CSS and JavaScript. Make the whole thing one long page with section headers and a table of contents. Don't use tabs for the top-level structure. Basic responsive styling so you can view it on a phone is nice too. Put the file in a global place on my computer outside of the code repo, and make sure the filename always starts with today's date in `YYYY-MM-DD-` format, because it helps keep the files time-sorted and out of version control. For example: /tmp/2026-01-12-explanation-<slug>.html
- Please write with the clarity and flow of Martin Kleppmann, making it engaging and written in classic style. Transitions between sections should be smooth.
- Bias toward diagrams: whenever a structure, relationship, or flow is clearer as a picture than as prose, draw it. Good candidates: data flow, component relationships, request lifecycles, state machines, pipelines, layered architectures. Skip diagrams for trivially sequential things that a sentence covers.
- Ideally, pick a small number of diagram families that can be reused throughout the explanation to explain various cases. Some useful kinds:
  - A very simplified version of the UI that the user sees in the app, to explain UI changes.
  - A system diagram showing data flow or communication between components. Make sure to include example data here!
- Don't use ASCII diagrams. Always use simple HTML designs for your diagrams, HTML lists for lists of things, etc.
  - For code blocks, always use `<pre>` tags. If you use a custom styled div instead, it **must** have
    `white-space: pre-wrap` in its CSS, or the browser will collapse all newlines into a single line.
    Before saving the file, scan each code block in the HTML source and confirm its CSS includes
    `white-space: pre` or `pre-wrap`.
- Use callouts for key concepts or definitions, important edge cases, etc.
- Once the file is fully written and verified, open it in my default browser with `open <path-to-file>`.
