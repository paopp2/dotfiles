---
name: claude-in-split
description: Use when spawning a new Claude Code session in a tmux pane with a bootstrap prompt already submitted, such as delegating a task to a parallel session or starting work in another repo
---

# Claude in Split

Open a fresh Claude Code session in a tmux pane, in a chosen directory, with a prompt
already submitted. The result is a live REPL the user can keep typing into.

## Recipe

Write the prompt to a file so quotes, backticks, and `$` cannot break the nested shell
quoting:

```bash
PROMPT_FILE=$(mktemp /tmp/claude-bootstrap.XXXXXX)
cat > "$PROMPT_FILE" <<'EOF'
<prompt, verbatim>
EOF
```

Then use the `tmux-split` skill to open the pane. Take `$CLAUDE_PANE` from its
pane-detection block, do not re-derive it here. The command must be wrapped in **double**
quotes, since it contains single quotes of its own:

```bash
tmux-split --source-pane "$CLAUDE_PANE" --print-pane-id -- \
  "zsh -ic 'cd <dir> && cc \"\$(cat $PROMPT_FILE)\"; exec zsh'"
```

`cc` is the shell function that starts `claude` on the account with the most usage to
spare. To force one, put its name before the prompt: `cc work ...` or `cc personal ...`.

Then always confirm it landed:

```bash
tmux capture-pane -p -t <pane-id> | head -25
```

## Rules

- **Keep the prompt short, reference large content by path.** `Read <file>, then ...`
  beats inlining a document: argv has an OS size limit and the CLI has been reported to
  reject very large prompts outright.
- **Verify the target directory exists first.** A failed `cd` leaves a dead pane.
- **Use `<<'EOF'`, not `<<EOF`**, or the outer shell expands `$` and backticks in the
  prompt before it is written.
- **`zsh -ic` is required** so `.zshrc` defines `cc`. Plain `sh -c` will not find it.
- **`exec zsh`** keeps the pane usable after the session exits.
- **No duplicate panes** for a purpose an existing pane already serves.

## Gotchas

**Trust dialog.** Folder trust is kept per account, under `projects` in `~/.claude.json`
for the default account and in `<config dir>/.claude.json` for the others. A directory
the picked account has not seen opens with the folder-trust prompt, and the bootstrap
prompt waits silently behind it until someone answers. Capturing the pane is the only
way to see this. Note that `/tmp` resolves to `/private/tmp`, a separate entry.

**Permission prompts.** An unattended bootstrap prompt stops at the first tool
permission request. Add `--dangerously-skip-permissions` to the `cc` call, before the
prompt, only when the user has asked for an unattended run.

**Launch flags are not inherited.** The new session does not get this one's `--add-dir`,
`--mcp-config`, or `--settings`. Pass them again if it needs them.

## Variants

Detached session instead of a visible pane:

```bash
tmux new-session -d -s <name> -c <dir> "zsh -ic 'cc \"\$(cat $PROMPT_FILE)\"; exec zsh'"
```

To fork the *current* conversation rather than start a fresh one, use `/fork-in-split`.
