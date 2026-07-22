#!/bin/sh
# Map a tmux pane to the Codex session currently running in it so the tmux
# fork bindings can target the source pane's exact conversation.
[ -n "$TMUX_PANE" ] || exit 0

input=$(cat)
sid=$(printf '%s' "$input" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -n "$sid" ] || exit 0

dir="$HOME/.codex/tmux-pane-sessions"
mkdir -p "$dir"
printf '%s' "$sid" > "$dir/$TMUX_PANE"
