# fzf-powered dstask helpers. Sourced from ~/.zsh_aliases.
# Requires: dstask, fzf, jq

# tp: fuzzy-pick a task, then run an action via hotkey.
#   Enter  view task
#   C-s    start
#   C-p    stop (pause)
#   C-d    done
#   C-n    note (opens $EDITOR)
#   C-e    edit (opens $EDITOR with full task YAML)
#   C-x    remove
tp() {
  local json
  json="$(dstask 2>/dev/null)"
  if [[ -z "$json" || "$json" == "[]" ]]; then
    echo "No tasks."
    return 0
  fi

  local out id key
  out="$(print -r -- "$json" | jq -r '
      .[] | [
        (.id | tostring),
        .priority,
        .status,
        (if .project == "" then "-" else .project end),
        .summary,
        (if (.tags | length) > 0 then "+" + (.tags | join(" +")) else "" end)
      ] | @tsv' \
    | fzf --layout=reverse \
          --delimiter=$'\t' \
          --with-nth=1,2,3,4,5,6 \
          --preview='dstask {1}' \
          --preview-window='right:55%:wrap' \
          --header='enter:view  C-s:start  C-p:stop  C-d:done  C-n:note  C-e:edit  C-x:remove' \
          --expect='ctrl-s,ctrl-p,ctrl-d,ctrl-n,ctrl-e,ctrl-x')" || return

  [[ -z "$out" ]] && return 0
  key="${out%%$'\n'*}"
  id="$(print -r -- "${out#*$'\n'}" | cut -f1)"

  case "$key" in
    ctrl-s) dstask "$id" start ;;
    ctrl-p) dstask "$id" stop ;;
    ctrl-d) dstask "$id" done ;;
    ctrl-n) dstask "$id" note ;;
    ctrl-e) dstask "$id" edit ;;
    ctrl-x) dstask "$id" remove ;;
    *)      dstask "$id" ;;
  esac
}

# _tca_flush_notes: internal helper. Injects note content for a task via
# an EDITOR wrapper + DSTASK_FAKE_PTY (dstask's inline note arg is broken
# in v1.0.1, so we go through the editor path non-interactively).
# args: $1=task id  $2=task summary  $3=tempfile with bullets (one per line)
_tca_flush_notes() {
  local id="$1" summary="$2" bullets="$3"
  [[ -z "$id" || ! -s "$bullets" ]] && return 0

  local notes wrapper
  notes="$(mktemp -t dstask-tca-notes.XXXXXX)"
  wrapper="$(mktemp -t dstask-tca-ed.XXXXXX)"
  {
    printf 'Task: %s\n\n' "$summary"
    cat "$bullets"
  } > "$notes"

  cat > "$wrapper" <<EOS
#!/bin/sh
cp "$notes" "\$1"
EOS
  chmod +x "$wrapper"
  DSTASK_FAKE_PTY=1 EDITOR="$wrapper" dstask "$id" note >/dev/null 2>&1
  rm -f "$wrapper" "$notes"
}

# tca: batch-create tasks in a project via $EDITOR.
#   Pick project (or create new), opens editor with a markdown-list template.
#   - Task summary [+tag] [P0-P3]        (col 0)
#       - Note bullet                    (indented)
#   Indented bullets become notes with a "Task: <summary>" header.
tca() {
  local projects options project new_marker='+ Create new project...'
  projects="$(dstask show-projects 2>/dev/null \
    | jq -r '.[] | select(.name != "") | .name' \
    | sort -u)"

  if [[ -n "$projects" ]]; then
    options="${new_marker}"$'\n'"${projects}"
  else
    options="$new_marker"
  fi

  project="$(print -r -- "$options" | fzf --layout=reverse \
    --header='select project for new tasks (esc to cancel)' \
    --height=40%)" || return 0

  [[ -z "$project" ]] && return 0

  if [[ "$project" == "$new_marker" ]]; then
    printf 'New project name: '
    read -r project
    if [[ -z "$project" ]]; then
      echo 'No project name entered. Aborting.'
      return 1
    fi
    if [[ ! "$project" =~ ^[A-Za-z0-9._-]+$ ]]; then
      echo 'Invalid project name. Use only letters, digits, dots, hyphens, underscores.'
      return 1
    fi
  fi

  local tmp
  tmp="$(mktemp -t dstask-tca.XXXXXX)"
  mv "$tmp" "${tmp}.md"
  tmp="${tmp}.md"
  cat > "$tmp" <<EOS
# Project: $project
#
# Format:
#   - Task summary [+tag] [P0-P3]
#       - Note bullet
#       - Another note bullet
#
# Lines starting with # are ignored. Save/quit to create. Empty = no-op.

-
EOS
  "${EDITOR:-vi}" "$tmp"

  local line stripped indent content add_out
  local current_id='' current_summary='' bullets=''
  local tasks_created=0 orphan_count=0 empty_count=0

  bullets="$(mktemp -t dstask-tca-bullets.XXXXXX)"

  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "${line//[[:space:]]/}" ]] && continue
    [[ "$line" =~ ^[[:space:]]*# ]] && continue

    stripped="${line#"${line%%[![:space:]]*}"}"
    indent=$(( ${#line} - ${#stripped} ))

    if [[ ! "$stripped" =~ ^-[[:space:]]*(.*)$ ]]; then
      (( orphan_count++ ))
      continue
    fi
    content="${match[1]}"

    if (( indent == 0 )); then
      _tca_flush_notes "$current_id" "$current_summary" "$bullets"
      : > "$bullets"
      current_id=''
      current_summary=''

      if [[ -z "$content" ]]; then
        (( empty_count++ ))
        continue
      fi

      add_out="$(dstask add ${=content} project:"$project" 2>&1)"
      current_id="$(print -r -- "$add_out" | grep -oE '^Added [0-9]+' | head -1 | awk '{print $2}')"
      current_summary="$(print -r -- "$add_out" | grep -E '^Added [0-9]+: ' | head -1 | sed -E 's/^Added [0-9]+: //')"
      [[ -z "$current_summary" ]] && current_summary="$content"
      [[ -n "$current_id" ]] && (( tasks_created++ ))
    else
      if [[ -z "$current_id" ]]; then
        (( orphan_count++ ))
        continue
      fi
      printf -- '- %s\n' "$content" >> "$bullets"
    fi
  done < "$tmp"

  _tca_flush_notes "$current_id" "$current_summary" "$bullets"
  rm -f "$bullets" "$tmp"

  echo "Created $tasks_created task(s) in project:$project"
  (( orphan_count > 0 )) && echo "Warning: skipped $orphan_count orphan/unparseable line(s)"
  (( empty_count > 0 )) && echo "Warning: skipped $empty_count empty task line(s)"
}

# tc: fuzzy-pick a project and set as context. Select "(none)" to clear.
tc() {
  local projects project
  projects="$(dstask show-projects 2>/dev/null \
    | jq -r '.[] | select(.name != "") | .name' \
    | sort -u)"

  project="$(printf '(none)\n%s' "$projects" \
    | fzf --layout=reverse \
          --header='select project to set as context (esc to cancel)' \
          --height=40%)" || return

  [[ -z "$project" ]] && return 0

  if [[ "$project" == "(none)" ]]; then
    dstask context none
  else
    dstask context "project:$project"
  fi
}
