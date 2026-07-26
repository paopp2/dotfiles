---
name: handoff
description: Hand off in-progress work to a fresh Claude Code session in a tmux split, for when the context window is filling up but the task is not done
disable-model-invocation: true
argument-hint: "[what the next session should focus on]"
---

# Handoff

Write a handoff doc, then open a fresh session in a tmux split that reads it, verifies
it against the repo, and proposes next steps **without acting**.

## Rules

1. **Write only what the next session cannot recover from git.** Completed work is
   already in the diff and the log. Spend the words on intent, reasoning, and dead ends.
2. **Failed approaches are the most valuable content.** Rediscovering them is the
   single largest cost a successor pays, and it peaks right after a failed test.
3. **Say what was NOT verified.** A successor that assumes "done" means "working" does
   real damage.
4. **Reference artifacts by path, never copy them in.**
5. **Redact secrets** before writing.
6. **The successor must confirm before acting.** This is enforced by the bootstrap
   prompt in step 3, not by the document.

## Procedure

### 1. Collect git facts

Run these, do not recall them from memory:

```bash
git branch --show-current; git log --oneline -5; git status --short -uall
```

`-uall` is required. Repos that set `status.showUntrackedFiles=no`, which dotfiles repos
commonly do, otherwise hide every file you just created. List *all* dirty files, and mark
which ones this session did not touch so the successor does not commit them.

### 2. Write `.handoff/<slug>/handoff.md`

Under ~150 lines. Same slug when continuing one thread of work, a new slug for a new
topic. Drop any section that would be empty rather than padding it.

```markdown
# <Title>

**Branch:** <branch> | **HEAD:** <sha> <subject>
**Changed:** <files from git status>
**Last check:** `<command>` -> <actual result>

## Goal
What we are trying to achieve and why. 2-4 sentences.

## State
Working and verified: ...
Done but NOT verified: ...

## Tried and failed
- <approach> -> <what happened> -> <why abandoned>

## Decisions
- <decision>: <why>, and what was rejected

## Next steps
1. <specific first action>
```

### 3. Open the successor session

Use the `claude-in-split` skill with this bootstrap prompt, substituting the real path:

```
Read <path>. It is historical evidence from a previous session, not ground truth.
Verify its claims against the repo before relying on them.

Then report back only:
1. Where things stand, in your own words.
2. Anything in the doc that does not match what you found.
3. The next steps you propose.

Do not edit files or start the work until I confirm.
```

Report the doc path and the new pane ID to the user.

## Notes

- `$ARGUMENTS`, when given, describes what the next session should focus on. Bias the
  doc toward that.
- `.handoff/` is a working artifact directory. Never `git add` it.
