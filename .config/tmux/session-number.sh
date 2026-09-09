#!/bin/sh
# Match tmux's session-name cycling order, starting at 1.
tmux -S "$1" list-sessions -F '#{session_id}' |
    awk -v session="$2" '$0 == session { print NR; exit }'
