---
name: review-doc
description: Use when setting up a markdown document for user review, such as design docs, plans, or research output
---

# Review Doc

## Overview

Open a markdown file for user review in a new tmux pane using yazi, then auto-trigger the configured opener (nvim with Peek for `.md` files).

## How to Use

Detect Claude Code's pane, then call the `review-doc` script:

```bash
CLAUDE_TTY=$(ps -o tty= -p $PPID | tr -d ' ')
CLAUDE_PANE=$(tmux list-panes -s -F '#{pane_id} #{pane_tty}' | grep "$CLAUDE_TTY" | awk '{print $1}')
review-doc --source-pane "$CLAUDE_PANE" <file-path>
```

Replace `<file-path>` with the path to the markdown file.

## Key Details

- **No duplicates:** Do NOT open a new pane if one is already open for the same directory. If a plan is written after a design was reviewed, reuse the existing pane since they share the same directory.
- **Delay:** The 1-second delay for the yazi opener is handled by the script.
