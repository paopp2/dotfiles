#!/bin/sh
# Map tmux pane -> Claude session id, so tmux keybinds can fork the pane's own
# session via `claude --resume` instead of guessing with `claude --continue`.
# Registered for SessionStart (write) and SessionEnd (compare-and-delete).
[ -n "$TMUX_PANE" ] || exit 0

input=$(cat)
sid=$(printf '%s' "$input" | sed -n 's/.*"session_id":"\([^"]*\)".*/\1/p')
[ -n "$sid" ] || exit 0

dir="$HOME/.claude/tmux-pane-sessions"
f="$dir/$TMUX_PANE"
event=$(printf '%s' "$input" | sed -n 's/.*"hook_event_name":"\([^"]*\)".*/\1/p')
if [ "$event" = "SessionEnd" ]; then
    # Delete only if this session still owns the pane. Guards against the
    # SessionEnd/SessionStart ordering on /clear, where the new session id
    # may already have been written.
    [ -f "$f" ] && [ "$(cat "$f")" = "$sid" ] && rm -f "$f"
else
    mkdir -p "$dir"
    printf '%s' "$sid" > "$f"
fi
