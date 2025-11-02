---
allowed-tools: Bash(git:*)
description: Create atomic git commits from working tree changes
model: claude-haiku-4-5-20251001
---

# Create Atomic Commits Command

You are tasked with creating atomic git commits from the current working tree changes. Each commit should represent a single logical change, following the repository's commit message conventions.

## ⚠️ CRITICAL: ABSOLUTELY ZERO CODE MODIFICATIONS ALLOWED

**THIS IS A READ-ONLY COMMIT ORGANIZATION OPERATION.**

Your ONLY job is to take existing changes in the working tree and organize them into well-structured atomic commits. You are NOT implementing anything. You are NOT fixing anything. You are ONLY organizing what already exists.

**YOU MUST NOT:**
- Modify any code files in any way whatsoever
- Fix bugs or issues you find in the changes
- Refactor or improve existing code
- Add, remove, or modify comments or documentation
- Format, lint, or clean up files
- Change indentation, whitespace, or styling
- Make ANY modifications to the working tree changes
- Touch the implementation AT ALL

**YOU CAN AND SHOULD:**
- Read files to understand what changes exist (using Read tool or git diff/git status)
- Stage existing changes exactly as they are (using git add, git add -p, git add -e)
- Create atomic commits from those unchanged changes
- Write appropriate commit messages based on what you read

**YOU ABSOLUTELY CANNOT:**
- Use Edit or Write tools under any circumstances
- Modify any file in any way
- Change even a single character of the implementation
- Run formatters, linters, or any tool that modifies files
- "Improve" or "fix" anything in the changes

**IF YOU MODIFY EVEN ONE CHARACTER OF CODE, YOU HAVE COMPLETELY FAILED THIS TASK.**

The working tree changes are SACRED and UNTOUCHABLE. Your role is purely organizational - splitting existing changes into logical commits.

## Understanding Atomic Commits

**Atomic commits** mean each commit should:
- Represent **one logical change** (e.g., fix one bug, add one feature, refactor one component)
- Be **self-contained** and compilable
- Have **focused scope** (possibly just part of a file, or specific files related to one change)
- Make the git history **clear and bisectable**

**IMPORTANT**: Having many small atomic commits is **strongly preferred** over fewer large commits. Don't worry about creating "too many" commits—more granular commits make the history easier to understand, review, and bisect. When in doubt, split changes into smaller commits.

## Process Overview

**REMEMBER**: This is purely an organizational task. The implementation work is already complete in the working tree. You are ONLY splitting those existing changes into logical commits. DO NOT modify any code during this process.

**Expected Outcome**: You should typically create **many commits** (10, 20, or even more) from your working tree changes. Each commit should be as small and focused as possible while still being self-contained.

1. **Analyze working tree changes** (read-only, no modifications)
2. **Group changes logically** into atomic units (lean toward more, smaller units)
3. **Stage and commit each atomic unit** separately (existing changes only, no modifications)
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
- Parts of files interactively: `git add -p path/to/file.ts` (select hunks interactively)
- Parts of files with edit mode: `git add -e path/to/file.ts` (manually edit what to stage)
- Multiple related files: `git add file1.ts file2.ts`

**Partial File Staging Example**:
```bash
# Interactive patch mode - select hunks one by one
git add -p src/file.ts
# Press 'y' to stage a hunk, 'n' to skip, 's' to split, 'e' to edit

# Edit mode - open editor to manually select what to stage
git add -e src/file.ts
# Delete '+' lines you don't want to stage
# Change '-' to ' ' (space) for deletions you don't want to stage

# Verify what's staged
git diff --staged
```

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

### Partial Files - Interactive Patch Mode (Recommended)
When a file has multiple unrelated changes, use patch mode to interactively select hunks:
```bash
# Stage changes interactively from user.ts
git add -p src/user.ts
# You'll see hunks one by one. Options:
#   y - stage this hunk
#   n - don't stage this hunk
#   s - split this hunk into smaller hunks
#   e - manually edit this hunk
#   ? - show help

git diff --staged  # Verify what's staged
git commit -m "fix: prevent null pointer in getUserById"

# Stage next logical change
git add -p src/user.ts
git diff --staged  # Verify what's staged
git commit -m "refactor: simplify user validation logic"

# Stage remaining changes
git add src/user.ts
git commit -m "feat: add new user property"
```

### Partial Files - Edit Mode (For Precise Line Control)
When you need precise control over which specific lines to stage, use edit mode:
```bash
# Open editor to manually select lines from user.ts
git add -e src/user.ts
# In the editor you'll see a patch with:
#   Lines starting with '+' are additions - DELETE these lines to NOT stage them
#   Lines starting with '-' are deletions - CHANGE to ' ' (space) to NOT stage the deletion
#   Lines starting with ' ' are context - LEAVE THESE ALONE
# Save and close the editor to stage your selection

git diff --staged  # Verify what's staged
git commit -m "fix: prevent null pointer in getUserById"

# Repeat for next logical change
git add -e src/user.ts
git commit -m "refactor: simplify user validation logic"
```

**CRITICAL REMINDER**: You are ONLY selecting which existing changes to stage. DO NOT modify the changes themselves. DO NOT fix bugs, format code, or improve anything. ONLY choose what to stage exactly as it exists.

## Error Handling

- **Pre-commit hooks modify files**: Amend the commit to include hook changes
- **Hooks block commit**: Explain the issue, never use `--no-verify`
- **No changes staged**: Move to next atomic unit or finish
- **Conflicts in partial staging**: Stage full file and document in message

## Important Constraints

- **ABSOLUTELY ZERO CODE MODIFICATIONS - ZERO TOLERANCE POLICY**: This command is ONLY for organizing existing changes into commits. You are NOT implementing features, NOT fixing bugs, NOT improving code. Only stage and commit existing changes exactly as they are. Do not touch the code at all. Not even whitespace. Not even formatting. Not even comments. Nothing. This is a hard, non-negotiable requirement. The implementation is COMPLETE and UNTOUCHABLE.

- **This is purely organizational work**: You are organizing completed work into logical commits. The "what" has already been implemented. You are ONLY organizing the "how it's committed."

- **Reading is allowed and required**: Use Read tool or git commands (git diff, git status) to understand what changes exist and write accurate commit messages based on what you find.

- **Edit and Write tools are STRICTLY FORBIDDEN**: Do not use Edit or Write tools under any circumstances. These tools modify files, and file modification is absolutely prohibited in this command.

- **No modification tools allowed**: Do not run formatters, linters, or any tool that changes files. Only use git commands for reading (git diff, git status, git log) and staging (git add).

- **Follow project conventions**: Match existing commit style exactly by studying git log output.

- **Handle hooks properly**: Never bypass hooks with `--no-verify`. If hooks modify files, amend the commit.

- **Verify each commit**: Check that each commit represents one logical change and nothing more.

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
