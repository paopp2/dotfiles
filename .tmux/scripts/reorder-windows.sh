#!/bin/bash
current_window_id=$(tmux display-message -p '#{window_id}')
tmp=$(mktemp)
tmux list-windows -F '#{window_index}: #{window_name}' > "$tmp"

nvim "$tmp"

# Move all windows to high temp indices to avoid collisions
offset=1000
while IFS=: read -r idx _; do
  tmux move-window -s :"$idx" -t :"$offset"
  offset=$((offset + 1))
done < "$tmp"

# Move them back to final positions
offset=1000
pos=1
while IFS=: read -r _ _; do
  tmux move-window -s :"$offset" -t :"$pos"
  offset=$((offset + 1))
  pos=$((pos + 1))
done < "$tmp"

rm "$tmp"

tmux select-window -t "$current_window_id"
