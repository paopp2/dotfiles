# Implement Plan

You are tasked with executing an implementation plan step by step. Follow these guidelines:

## Setup
1. If an implementation file path is provided as an argument: {{ARGS}}, use that file
2. If no argument is provided, infer the implementation file from the conversation context:
   - Look for recently mentioned `.plan/` files
   - Check for `.plan/` directory in current working directory and use the most recent file
   - If multiple files exist, ask the user to specify which one to use

## Implementation Process

### Step-by-Step Execution
- Read and understand the complete implementation plan
- Execute each phase and substep in the exact order specified in the plan
- Complete one step fully before moving to the next
- Follow all guidelines and constraints mentioned in the plan

### After Each Significant Change
1. **Analyze the actual changes made** (not just the task completed)
2. **Suggest an appropriate git commit message** based on the specific code changes
3. **Do NOT run `git add`** - the user handles all file staging
4. **Wait for the "COMMIT" signal** before proceeding with `git commit`

### Handling User Feedback
- If no "COMMIT" signal is given, assume one of the following:
  - User wants to make manual changes
  - User has clarifying questions
  - User wants modifications to the current changes
- Respond accordingly and wait for further instructions
- Only proceed to the next step after receiving the "COMMIT" signal

### Important Guidelines
- **Never run `git add`** - user handles staging
- Always check for manual user changes before suggesting commits
- Base commit messages on actual code changes, not task descriptions
- Follow existing code conventions found in the codebase
- Prioritize editing existing files over creating new ones
- Ask clarifying questions if any step in the plan is unclear
- Stop and wait for user input whenever uncertain

## Process Flow
1. Load the implementation plan from the specified or inferred file
2. Present a summary of the phases to be implemented
3. Begin with Phase 1, Step 1
4. For each completed step:
   - Show what was changed
   - Suggest a commit message based on actual changes
   - Wait for "COMMIT" signal before proceeding
5. Continue until all phases are complete

Remember: The user controls the git workflow. Your job is to implement the code changes and suggest appropriate commit messages, then wait for explicit approval to commit and proceed.