---
allowed-tools: Bash(git:*)
description: Create atomic git commits from working tree changes
---

# Create Atomic Commits Command

You are tasked with creating atomic git commits from the current working tree changes. Each commit should represent a single logical change, following the repository's commit message conventions.

## Understanding Atomic Commits

**Atomic commits** mean each commit should:
- Represent **one logical change** (e.g., fix one bug, add one feature, refactor one component)
- Be **self-contained** and compilable
- Have **focused scope** (possibly just part of a file, or specific files related to one change)
- Make the git history **clear and bisectable**

**IMPORTANT**: Having many small atomic commits is **strongly preferred** over fewer large commits. Don't worry about creating "too many" commits—more granular commits make the history easier to understand, review, and bisect. When in doubt, split changes into smaller commits.

## Process Overview

**Expected Outcome**: You should typically create **many commits** (10, 20, or even more) from your working tree changes. Each commit should be as small and focused as possible while still being self-contained.

1. **Analyze working tree changes**
2. **Group changes logically** into atomic units (lean toward more, smaller units)
3. **Stage and commit each atomic unit** separately
4. **Follow repository's commit message style**

## Step-by-Step Execution

### 1. Analyze Current Changes

Run these commands to understand the full scope:
```bash
git status
git diff
git log --oneline -10
```

Analyze:
- What files have changes?
- What types of changes exist? (features, fixes, refactors, docs, tests, etc.)
- What's the repository's commit message convention?

### 2. Identify Atomic Units

Group changes into logical, independent units. **Err on the side of smaller commits**. Examples:
- Separate feature additions from bug fixes
- Separate refactoring from new functionality
- Separate test changes from implementation changes
- Split unrelated changes in the same file
- Split a large feature into multiple small steps (e.g., "add function signature", "add implementation", "add validation")

**Important**: You can stage:
- Entire files: `git add path/to/file.ts`
- Parts of files: `git add -p path/to/file.ts` (interactive staging)
- Multiple related files: `git add file1.ts file2.ts`

**Remember**: If you're unsure whether changes should be in one commit or two, split them into two. More commits is always better than fewer.

### 3. Create Each Atomic Commit

For each logical unit:

1. **Stage only the relevant changes**:
   ```bash
   git add <specific-files-or-use-patch-mode>
   ```

2. **Verify what's staged**:
   ```bash
   git diff --staged
   ```

3. **Draft commit message** based on:
   - Repository's existing style (from git log)
   - Actual staged changes (not user instructions)
   - Single logical purpose of this atomic unit
   - Focus on "why" over "what"

4. **Create the commit**:
   ```bash
   git commit -m "$(cat <<'EOF'
   Your commit message here
   EOF
   )"
   ```

5. **Verify success**:
   ```bash
   git status
   git log -1 --stat
   ```

### 4. Repeat Until Working Tree is Clean

Continue the process until `git status` shows no uncommitted changes.

## Commit Message Guidelines

### Style Detection
- **Match repository format exactly**: Study `git log` output
- **Common patterns**:
  - Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
  - Imperative mood: `Add feature`, `Fix bug`, `Refactor component`
  - Other: Capitalization, punctuation, length

### Message Content
- **Base on staged diff**: Not on what user originally requested
- **One change per commit**: "Add validation" not "Add validation and fix bug"
- **Be specific**: "Fix null pointer in user login" not "Fix bug"
- **Focus on why**: Explain the purpose, not just what changed
- **Be concise**: 1-2 sentences maximum

## Attribution Rules

**NEVER include**:
- AI authorship mentions
- Co-author tags for Claude Code or AI tools
- Any AI-generation indicators

## Examples of Atomic Commits

### Good Atomic Commits (More is Better!)
```
Commit 1: feat: add email validation function signature
Commit 2: feat: implement email validation logic
Commit 3: feat: integrate email validation in user registration
Commit 4: fix: prevent null pointer exception in login handler
Commit 5: refactor: extract validation logic into separate file
Commit 6: refactor: update imports to use new validation module
Commit 7: test: add unit tests for email validator
Commit 8: test: add integration tests for user registration
Commit 9: docs: update API documentation for auth endpoints
Commit 10: docs: add inline comments to validation module
```

**Note**: Ten commits is perfectly fine and actually preferred over combining these changes. Don't hesitate to create even more granular commits.

### Bad (Non-Atomic) Commits
```
Commit 1: feat: add validation, fix bugs, and update docs
Commit 2: fix: various fixes and improvements
Commit 3: update: changed stuff
```

## Staging Strategies

### Entire Files
When entire files represent one atomic change:
```bash
git add src/validators/email.ts src/validators/phone.ts
git commit -m "feat: add email and phone validators"
```

### Partial Files (Patch Mode)
When a file has multiple unrelated changes:
```bash
git add -p src/user.ts
# Select only hunks related to one logical change
git commit -m "fix: prevent null pointer in getUserById"

# Then stage remaining changes separately
git add -p src/user.ts
git commit -m "refactor: simplify user validation logic"
```

## Error Handling

- **Pre-commit hooks modify files**: Amend the commit to include hook changes
- **Hooks block commit**: Explain the issue, never use `--no-verify`
- **No changes staged**: Move to next atomic unit or finish
- **Conflicts in partial staging**: Stage full file and document in message

## Important Constraints

- **NEVER modify code**: Only stage and commit existing changes
- **Follow project conventions**: Match existing commit style exactly
- **Handle hooks properly**: Never bypass with `--no-verify`
- **Verify each commit**: Check it represents one logical change
- **Prefer many small commits**: It's perfectly fine—and encouraged—to create dozens of tiny atomic commits. There is no such thing as "too many commits" as long as each is atomic. Ten 5-line commits are better than one 50-line commit.

## Success Criteria

- [ ] All working tree changes are committed
- [ ] Each commit represents one logical change
- [ ] Commit messages match repository style
- [ ] Messages accurately reflect staged changes
- [ ] All pre-commit hooks pass
- [ ] No AI attribution included
- [ ] Git history is clean and bisectable

Remember: Atomic commits make the git history a powerful tool for understanding code evolution, debugging with git bisect, and safely reverting specific changes.
