---
name: work-summary
description: Summarize all of your recent work across GitHub repositories. Use when the user asks to summarize their work, recap what they've done, or wants a standup/status update. Invoke as /work-summary with time range args like "3 days", "from last Friday", "this week", etc. Args can also include special instructions.
version: 1.0.0
---

# Work Summary

Summarize the user's recent work across all GitHub repositories for a given time period.

## Arguments

`{ARGS}` contains:
- A time range (required) — e.g., "3 days", "from last Friday", "this week", "since Monday"
- Optional special instructions — e.g., "focus on frontend work", "include PR links"

## Steps

### 1. Parse the time range

Convert the user's natural language time range into a `--since` date for git/gh commands. Use `date` command to compute the actual date if needed.

### 2. Fetch commits from GitHub

Use `gh` to search for the user's commits across all repos:

```bash
# Get the GitHub username
gh api user --jq '.login'

# Search for commits by the user across all repos within the time range
gh api search/commits --method GET -f q="author:{username} committer-date:>{since_date}" -f sort=committer-date -f per_page=100 --jq '.items[] | {repo: .repository.full_name, message: (.commit.message | split("\n") | .[0]), date: .commit.committer.date}'
```

If the search API has issues, fall back to listing the user's repos and checking each:

```bash
gh repo list {username} --limit 50 --json nameWithOwner --jq '.[].nameWithOwner'
```

Then for each repo:

```bash
gh api repos/{owner}/{repo}/commits --method GET -f author={username} -f since={since_date} --jq '.[].commit.message' 2>/dev/null
```

### 3. Check local repositories

Always check local git repos for commits and uncommitted work that may not have been pushed to GitHub. Use `zoxide` to discover frequently visited directories:

```bash
# Get top zoxide destinations and filter for git repos
zoxide query -l | head -30
```

For each directory that is a git repo (has `.git` or is inside a worktree), check for:

1. **Local commits** not yet on GitHub:
   ```bash
   git -C "{dir}" log --oneline --since="{since_date}" --author="{username}" --all 2>/dev/null
   ```

2. **Uncommitted/unstaged changes**:
   ```bash
   git -C "{dir}" status --short 2>/dev/null
   ```

**Deduplication:** Skip repos whose commits already appeared in the GitHub results from step 2. Match by repo name (basename of directory vs repo name from GitHub). Only include local repos that have *additional* activity not covered by GitHub.

### 4. Format output

Group commits by repository name (short name, not full path). Deduplicate and summarize related commits into concise bullet points.

**Output format:**

```
{repo-name}
- {summary of related commits, concise}
- {another summary}

{another-repo-name}
- {summary}
```

**Rules:**
- Use only the repo name (e.g., `eetech-commerce-cms`), not the full `owner/repo` path
- Merge related commits into a single bullet (e.g., multiple "fix typo" commits → one "Minor fixes and cleanup" bullet)
- Keep bullets concise — describe what was done, not individual commit messages
- Order repos by most recent activity first
- If there's no activity, say so clearly
- Follow any special instructions from `{ARGS}`
