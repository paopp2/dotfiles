---
name: create-pr
description: Create a draft pull request for the current branch. Use when the user asks to create a PR, open a pull request, or submit their work for review. Invoke as /create-pr with optional args for special instructions like "add a Demo section" or other customizations.
version: 1.0.0
---

# Create PR

Create a draft pull request for the current branch.

## Arguments

`{ARGS}` are optional special instructions, e.g.:
- "Add a Demo section for me to insert a demo"
- "Mark as ready for review" (non-draft)
- Other formatting/content instructions

## Prerequisites

You must be in a git repository on a feature branch (not main/master).

## Steps

### 1. Determine the base branch

```bash
# Find the default branch (main or master)
git remote show origin | grep 'HEAD branch' | awk '{print $NF}'
```

### 2. Understand the changes

Run these in parallel:

```bash
# Check current state
git status

# See all commits on this branch vs base
git log {base_branch}..HEAD --oneline

# See the full diff against base
git diff {base_branch}...HEAD --stat
```

### 3. Push the branch to remote

```bash
# Push with upstream tracking if not already pushed
git push -u origin HEAD
```

### 4. Create the draft PR

Analyze ALL commits (not just the latest) to write:
- **Title**: Short, descriptive, under 70 characters
- **Body**: Concise summary of changes

```bash
gh pr create --draft --title "{title}" --body "$(cat <<'EOF'
## Summary
{2-4 concise bullet points describing the changes}

{any additional sections from ARGS, e.g.:}
{## Demo}
{<!-- Insert demo here -->}
EOF
)"
```

### 5. Open the PR in the browser

```bash
gh pr view --web
```

**Rules:**
- Always create as `--draft` unless args explicitly say otherwise
- Target the default branch (main/master)
- Title should reflect the overall work, not a single commit
- Keep the summary short and useful — bullet points preferred
- If `{ARGS}` requests extra sections (e.g., "Demo"), add them to the body
- After creating, open the PR in the browser with `gh pr view --web`
- Return the PR URL when done
