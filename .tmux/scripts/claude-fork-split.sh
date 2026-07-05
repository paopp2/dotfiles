#!/bin/sh
# Split a pane and fork the Claude session running in it.
# usage: claude-fork-split.sh <-h|-v> <pane_id> <pane_current_path> [extra claude args...]
#
# Resolves the source pane's session via the map maintained by
# ~/.claude/hooks/track-tmux-pane-session.sh; falls back to --continue
# (most recent session in the directory) when the pane is unmapped or
# the mapped session's transcript no longer exists.
orient=$1
pane=$2
dir=$3
shift 3

resume="--continue"
f="$HOME/.claude/tmux-pane-sessions/$pane"
if [ -s "$f" ]; then
    sid=$(cat "$f")
    project=$(printf '%s' "$dir" | sed 's/[^A-Za-z0-9]/-/g')
    if [ -f "$HOME/.claude/projects/$project/$sid.jsonl" ]; then
        resume="--resume $sid"
    else
        rm -f "$f"
    fi
fi

tmux split-window "$orient" -t "$pane" -c "$dir" \
    "$HOME/.local/bin/claude $resume --fork-session $*"
tmux select-layout -t "$pane" -E
