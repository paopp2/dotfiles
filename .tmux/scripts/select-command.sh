#!/bin/sh
# Copy mode: highlight the previous/next command + its output, ready for `y`.
# Needs OSC 133;A prompt marks (see .zshrc). Usage: select-command.sh prev|next <pane-id>
dir=$1 pane=$2
skip=2 # lines between a prompt mark and the `$ cmd` line (Starship blank + info line)

x() { tmux send -t "$pane" -X "$@"; }
pos() { tmux display -p -t "$pane" '#{e|-:#{e|+:#{history_size},#{copy_cursor_y}},#{scroll_position}}'; }

# Cursor on a prompt mark: select that command through its output.
# Fails (selecting nothing) on the live prompt, which has no mark after it.
select_block() {
  i=0; while [ $i -lt $skip ]; do x cursor-down; i=$((i + 1)); done
  x start-of-line
  start=$(pos)
  x begin-selection
  x next-prompt
  if [ "$(pos)" = "$start" ]; then x clear-selection; return 1; fi
  x cursor-up
  x end-of-line
}

has_selection=$(tmux display -p -t "$pane" '#{selection_present}')
x clear-selection

if [ "$dir" = next ] && [ "$has_selection" = 1 ]; then
  x next-prompt
  select_block && exit
  # Already on the last command: keep it highlighted.
  x previous-prompt
  x previous-prompt
  select_block
else
  # prev, or next with nothing highlighted yet: step back one command.
  x previous-prompt
  x previous-prompt
  select_block
fi
