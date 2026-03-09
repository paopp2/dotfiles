---
description: Fork the current conversation into a new tmux pane
---

Fork the current conversation into a new tmux pane so both sessions are visible side by side.

## Instructions

1. Use the `tmux-split` skill to open a new pane
2. The command to run in the new pane is: `claude --continue --fork-session --dangerously-skip-permissions`
3. This will fork the most recent session in the current working directory into the new pane
4. The original session stays in the current pane, untouched
