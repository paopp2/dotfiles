#!/bin/sh

if [ "$1" = "--move" ]; then
    sleep 0.1
    if ! window=$(tmux break-pane -dP -F '#{window_id}' -s "$2" -t "$3:" 2>&1); then
        error=$window
        tmux display-message "Could not move pane: $error"
        exit
    fi
    tmux select-window -t "$window"
    tmux switch-client -c "$4" -t "$3"
    tmux select-pane -t "$2"
    exit
fi

pane=$1
client=$2

selection=$(tmux list-sessions -F '#{session_id} #{session_name}' |
    fzf --prompt='Move pane to session: ' --height=100% --layout=reverse)

[ -n "$selection" ] || exit 0

session=${selection%% *}
tmux run-shell -b "TMUX='$TMUX' '$0' --move '$pane' '$session' '$client'"
