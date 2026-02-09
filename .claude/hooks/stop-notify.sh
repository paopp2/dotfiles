#!/bin/bash

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')

if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

MSG="Done"

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
  FULL_TEXT=$(tac "$TRANSCRIPT_PATH" | while IFS= read -r line; do
    role=$(echo "$line" | jq -r '.message.role // empty' 2>/dev/null)
    if [ "$role" = "assistant" ]; then
      text=$(echo "$line" | jq -r '[.message.content[] | select(.type == "text") | .text] | join("\n")' 2>/dev/null)
      if [ -n "$text" ] && [ "$text" != "null" ]; then
        echo "$text"
        break
      fi
    fi
  done)

  if [ -n "$FULL_TEXT" ]; then
    # Get the last non-empty line
    MSG=$(echo "$FULL_TEXT" | sed '/^[[:space:]]*$/d' | tail -1)
  fi
fi

if [ -z "$MSG" ]; then
  MSG="Done"
fi

# Prefix with tmux session name and window number if inside tmux
if [ -n "$TMUX" ]; then
  TMUX_SESSION=$(tmux display-message -p '#S' 2>/dev/null)
  TMUX_WINDOW=$(tmux display-message -p '#I' 2>/dev/null)
  if [ -n "$TMUX_SESSION" ] && [ -n "$TMUX_WINDOW" ]; then
    MSG="[$TMUX_SESSION $TMUX_WINDOW]: $MSG"
  fi
fi

# Truncate to 200 chars and escape for AppleScript
MSG=$(echo "$MSG" | tr '\n' ' ' | head -c 200 | sed 's/\\/\\\\/g; s/"/\\"/g')

osascript -e "display notification \"$MSG\" with title \"Claude Code\" sound name \"Blow\""
