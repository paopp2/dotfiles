---
name: tmux-split
description: Use when needing to open a command in a new tmux pane from Claude Code, such as opening docs for review, forking conversations, or running commands in a side pane
---

# Tmux Split

## Overview

Open a command in a new tmux pane, automatically targeting Claude Code's own pane and choosing the best split orientation.

## How to Use

Detect Claude Code's pane, then call the `tmux-split` script:

```bash
CLAUDE_TTY=$(ps -o tty= -p $PPID | tr -d ' ')
CLAUDE_PANE=$(tmux list-panes -s -F '#{pane_id} #{pane_tty}' | grep "$CLAUDE_TTY" | awk '{print $1}')
tmux-split --source-pane "$CLAUDE_PANE" -- '<command>'
```

## Key Details

- **Pane detection:** `$PPID` resolves to Claude Code's node process → `ps -o tty=` finds its TTY → tmux lookup maps TTY to pane ID.
- **Interactive shell:** When the command needs shell aliases/functions, use `zsh -ic "<command>; exec zsh"` as the command.
- **Keep alive:** Append `exec zsh` to keep the pane open after the command exits.
- **No duplicates:** Do NOT open duplicate panes for the same purpose — check if one already exists before splitting.
- **Print pane ID:** Add `--print-pane-id` to capture the new pane's ID for further interaction.
