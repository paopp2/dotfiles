---
description: Execute staged implementation plan following development guidelines
---

# Implement Plan

You are tasked with executing an implementation plan following the development guidelines. Follow these principles:

## Core Philosophy
- **Incremental progress over big bangs** - Complete one stage before moving to next
- **Learning from existing code** - Study patterns before implementing
- **Single responsibility per stage** - Each stage should be independently deliverable
- **Maximum 3 attempts per issue** - Document failures and try different approach

## Setup
1. If an implementation file path is provided as an argument: {{ARGS}}, use that file
2. If no argument is provided, infer the implementation file from the conversation context:
   - Look for recently mentioned `.plan/` files
   - Check for `.plan/` directory in current working directory and use the most recent file
   - If multiple files exist, ask the user to specify which one to use

## Implementation Flow

### 1. Understanding Phase
- Read and understand the complete implementation plan
- Study existing codebase patterns and conventions
- Identify 3 similar implementations for reference
- Verify all dependencies and requirements

### 2. Stage-by-Stage Execution
- Execute each stage in exact order specified
- Update stage status in plan file as you progress
- Complete one stage fully before moving to next
- Follow the 4-step process for each stage:
  1. **Understand** - Study existing patterns
  2. **Test** - Write test first (if tests exist in codebase)
  3. **Implement** - Minimal code to achieve stage goal
  4. **Validate** - Run quality checks

### 3. After Each Stage Completion
1. **Update plan status** to "Complete"
2. **Analyze actual changes made** (not just task completed)
3. **Suggest commit message** based on specific code changes
4. **Never run `git add`** - user handles all staging
5. **Wait for "COMMIT" signal** before proceeding

### 4. When Stuck (Maximum 3 Attempts)
1. **Document what failed**: What you tried, errors, why it failed
2. **Research alternatives**: Find 2-3 different approaches
3. **Question fundamentals**: Is this the right abstraction level?
4. **Try different angle**: Different library/pattern/approach

## Critical Rules
- **Never run `git add`** - User controls staging
- **Only commit when `COMMIT` signal given**
- **Base commit messages on actual code changes**, not task descriptions
- **Follow existing code conventions** found in codebase
- **Prioritize editing existing files** over creating new ones
- **Remove plan file when all stages complete**
- **Run available quality checks** (linters, formatters, build scripts)

## Process Flow
1. Load implementation plan and present stage summary
2. Begin with Stage 1
3. For each stage:
   - Update status to "In Progress"
   - Execute using 4-step process
   - Update status to "Complete"
   - Show changes and suggest commit message
   - Wait for "COMMIT" signal before proceeding
4. Remove plan file when all stages complete

Remember: You implement the code changes and suggest commit messages. The user controls the git workflow entirely.