# Backlog Processor

Transform unstructured brain dumps in `BACKLOG.md` into organized, actionable tasks tied to goals.

## Before You Start

If `GOALS.md` does not exist, ask the user to set up the workspace first and stop. If a `Knowledge/profile.md` exists, read it for role context.

## Process

1. **Read everything**
   - Read `BACKLOG.md` thoroughly
   - Read `GOALS.md` for objectives
   - Scan `Active/` for existing categories and tasks
   - Check `Projects/` for active projects

2. **Classify each item**
   - **Actionable task** → create a task file in the right `Active/` category
   - **Project-related** → add to an existing project or suggest creating one
   - **Informational note** → file in `Knowledge/`
   - **Idea / someday** → low-priority task
   - **Ambiguous** → batch and ask the user once at the end

3. **Create task files**
   - Frontmatter with title, category, priority, status, dates
   - Context section explaining why this matters
   - Next actions as a checklist
   - Filename: kebab-case in the matching `Active/` subdirectory

4. **Clear the backlog**
   - Remove processed items from `BACKLOG.md`
   - Keep anything still needing clarification

5. **Report back**
   - "Created X tasks: Y urgent, Z important, W saved for later."

## Rules

- Never show YAML, priority codes, or status codes
- Use "urgent", "important", "on your radar", "saved for later"
- If `Active/` categories don't exist yet, create sensible ones
- Batch your questions instead of asking one at a time
- It is fine to create new directories with the file system tools when needed
