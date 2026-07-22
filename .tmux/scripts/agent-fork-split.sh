#!/bin/sh
# Preserve the same fork keys for Claude and Codex by dispatching based on the
# agent running in the source pane. Unknown panes retain the Claude behavior.
orient=$1
pane=$2
dir=$3
shift 3

command=$(tmux display-message -p -t "$pane" '#{pane_current_command}')
pane_pid=$(tmux display-message -p -t "$pane" '#{pane_pid}')
child_args=$(ps -axo ppid=,args= | awk -v parent="$pane_pid" '$1 == parent { sub(/^[^ ]+[[:space:]]+/, ""); print }')

case "$command $child_args" in
    codex*|*"/codex "*|*" codex "*)
        exec "$HOME/.tmux/scripts/codex-fork-split.sh" "$orient" "$pane" "$dir"
        ;;
    *)
        exec "$HOME/.tmux/scripts/claude-fork-split.sh" "$orient" "$pane" "$dir" "$@"
        ;;
esac
