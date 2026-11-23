---
description: Fork the current conversation into a new tmux pane
---

Fork the current conversation into a new tmux pane so both sessions are visible side by side.

## Instructions

1. Run this, exactly as written:

   ```bash
   ~/.tmux/scripts/claude-fork-split.sh -h "$TMUX_PANE" "$PWD" --dangerously-skip-permissions
   ```

2. It forks this session, on the account this session is on, into a new pane beside it
3. The original session stays in the current pane, untouched
