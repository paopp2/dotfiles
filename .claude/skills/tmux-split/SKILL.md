---
name: tmux-split
description: Use when needing to open a command in a new tmux pane from Claude Code, such as opening docs for review, forking conversations, or running commands in a side pane
---

# Tmux Split

## Overview

Open a command in a new tmux pane, automatically targeting Claude Code's own pane and choosing the best split orientation.

## How to Use

Run this bash snippet, replacing `<command>` with the command to run in the new pane:

```bash
CLAUDE_TTY=$(ps -o tty= -p $PPID | tr -d ' ')
CLAUDE_PANE=$(tmux list-panes -s -F '#{pane_id} #{pane_tty}' | grep "$CLAUDE_TTY" | awk '{print $1}')
PANE_WIDTH=$(tmux display-message -t "$CLAUDE_PANE" -p '#{pane_width}')
PANE_HEIGHT=$(tmux display-message -t "$CLAUDE_PANE" -p '#{pane_height}')
SPLIT_FLAG=$( [ "$PANE_WIDTH" -gt $((PANE_HEIGHT * 2)) ] && echo "-h" || echo "-v" )
tmux split-window $SPLIT_FLAG -t "$CLAUDE_PANE" '<command>'
```

## Key Details

- **Pane detection:** `$PPID` resolves to Claude Code's node process → `ps -o tty=` finds its TTY → tmux lookup maps TTY to pane ID. All values are dynamic per session.
- **Smart orientation:** If pane width > 2x height, split horizontally (side by side). Otherwise split vertically (top/bottom).
- **Interactive shell:** When the command needs shell aliases/functions, use `zsh -ic "<command>; exec zsh"` — plain `zsh -c` won't load `~/.zsh_aliases`.
- **Keep alive:** Append `exec zsh` to keep the pane open after the command exits.
- **No duplicates:** Do NOT open duplicate panes for the same purpose — check if one already exists before splitting.
