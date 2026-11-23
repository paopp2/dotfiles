#!/bin/sh
# Split a pane and fork the Claude session running in it.
# usage: claude-fork-split.sh <-h|-v> <pane_id> <pane_current_path> [extra claude args...]
#
# The fork starts on the account the source session is on, because that is
# where its transcript lives; cc-handover finds both. Without a Claude session
# in the pane, or without its transcript, it falls back to --continue (the
# most recent session in the directory) on the default account.
orient=$1
pane=$2
dir=$3
shift 3

# The default account must run with CLAUDE_CONFIG_DIR unset: setting it, even
# to ~/.claude, makes Claude look up a different login.
launch="env -u CLAUDE_CONFIG_DIR"
resume="--continue"
if where=$(TMUX_PANE=$pane "$HOME/.local/bin/cc-handover" --where 2>/dev/null); then
    sid=${where%% *}
    config=${where#* }
    if [ -n "$(find "$config/projects" -maxdepth 2 -name "$sid.jsonl" 2>/dev/null)" ]; then
        resume="--resume $sid"
        [ "$config" = "$HOME/.claude" ] || launch="env CLAUDE_CONFIG_DIR=$config"
    fi
fi

tmux split-window "$orient" -t "$pane" -c "$dir" \
    "$launch $HOME/.local/bin/claude $resume --fork-session $*"
tmux select-layout -t "$pane" -E
