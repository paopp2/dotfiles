# Create Implementation Plan

You are tasked with creating a comprehensive implementation plan for the user's request. Follow these guidelines:

## Setup
1. Create a `.plan/` directory in the current working directory if it doesn't exist
2. Generate a markdown implementation plan file in the `.plan/` directory with a descriptive filename

## Plan Structure
Create a detailed implementation plan that includes:

### Project Analysis
- Review existing codebase structure and conventions
- Identify relevant files and directories
- Check for existing patterns and frameworks in use
- Review both user's global CLAUDE.md and any project-specific CLAUDE.md files

### Implementation Strategy
- Break down the implementation into logical phases
- Each phase should have clear, actionable substeps
- Keep the approach simple while being comprehensive
- Identify potential dependencies between phases

### Clarification Requirements
- List any unclear requirements that need user clarification
- Identify assumptions that should be validated
- Note any missing information needed for implementation

### Phase-by-Phase Breakdown
For each phase:
- List specific tasks and substeps
- Suggest appropriate git commit messages based on the actual changes (not just task completion)
- Include verification/testing steps where applicable
- Note any manual user actions required

### Important Guidelines
- **Never run `git add`** - the user handles file staging
- Always check for manual changes made by the user before suggesting commits
- Wait for explicit "COMMIT" signal before proceeding with any git commits
- If no "COMMIT" signal is given, assume further clarification or feedback is needed
- Follow existing code conventions and patterns found in the codebase
- Prioritize editing existing files over creating new ones
- Only create files when absolutely necessary

## Process
1. Analyze the user's requirements: {{ARGS}}
2. Examine the current working directory and codebase
3. Create the implementation plan following the structure above
4. After creating the plan file, automatically open it in the user's active IDE using: `cursor -r ./.plan/{file_name}`
5. Present the plan to the user and wait for feedback or approval before proceeding

Remember: Do not make assumptions. When in doubt, ask clarifying questions.