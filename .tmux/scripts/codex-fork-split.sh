#!/bin/sh
# Split a pane and fork the exact Codex session running in it.
# usage: codex-fork-split.sh <-h|-v> <pane_id> <pane_current_path>
orient=$1
pane=$2
dir=$3

session_args="--last"
map="$HOME/.codex/tmux-pane-sessions/$pane"
if [ -s "$map" ]; then
    sid=$(cat "$map")
    session_args="$sid"
fi

tmux split-window "$orient" -t "$pane" -c "$dir" \
    "codex fork $session_args"
tmux select-layout -t "$pane" -E
