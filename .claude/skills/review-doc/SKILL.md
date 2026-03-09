---
name: review-doc
description: Use when setting up a markdown document for user review, such as design docs, plans, or research output
---

# Review Doc

## Overview

Open a markdown file for user review in a new tmux pane using yazi, then auto-trigger the configured opener (nvim with Peek for `.md` files).

## How to Use

1. Use the `tmux-split` skill to get the split command variables (`CLAUDE_PANE`, `SPLIT_FLAG`)
2. Split the pane with `-P -F '#{pane_id}'` to capture the new pane ID
3. Send `o` to the new pane after a brief delay to trigger the yazi opener

```bash
CLAUDE_TTY=$(ps -o tty= -p $PPID | tr -d ' ')
CLAUDE_PANE=$(tmux list-panes -s -F '#{pane_id} #{pane_tty}' | grep "$CLAUDE_TTY" | awk '{print $1}')
PANE_WIDTH=$(tmux display-message -t "$CLAUDE_PANE" -p '#{pane_width}')
PANE_HEIGHT=$(tmux display-message -t "$CLAUDE_PANE" -p '#{pane_height}')
SPLIT_FLAG=$( [ "$PANE_WIDTH" -gt $((PANE_HEIGHT * 2)) ] && echo "-h" || echo "-v" )
NEW_PANE=$(tmux split-window $SPLIT_FLAG -t "$CLAUDE_PANE" -P -F '#{pane_id}' 'zsh -ic "r <file-path>; exec zsh"')
sleep 1 && tmux send-keys -t "$NEW_PANE" 'o'
```

Replace `<file-path>` with the path to the markdown file.

## Key Details

- **No duplicates:** Do NOT open a new pane if one is already open for the same directory. If a plan is written after a design was reviewed, reuse the existing pane since they share the same directory.
- **Interactive shell:** `zsh -ic` is required so the `r` function (yazi wrapper from `~/.zsh_aliases`) is available.
- **Delay:** The 1-second delay gives yazi time to start before sending the `o` keypress.
