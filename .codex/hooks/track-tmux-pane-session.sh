#!/bin/sh
# Map a tmux pane to the Codex session currently running in it so the tmux
# fork bindings can target the source pane's exact conversation.
[ -n "$TMUX_PANE" ] || exit 0

input=$(cat)
sid=$(printf '%s' "$input" | jq -r '.session_id // empty') || exit 1
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty') || exit 1
[ -n "$sid" ] && [ -f "$transcript" ] || exit 0

# Side conversations can share TMUX_PANE without a resumable transcript.
# Only the persisted CLI conversation may replace the pane's session mapping.
head -n 1 "$transcript" | jq -e --arg sid "$sid" '
    .type == "session_meta" and .payload.id == $sid and .payload.source == "cli"
' >/dev/null || exit 0

dir="$HOME/.codex/tmux-pane-sessions"
mkdir -p "$dir"
printf '%s' "$sid" > "$dir/$TMUX_PANE"
