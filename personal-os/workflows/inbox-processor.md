# Inbox Processor

Transform brain dumps in `INBOX.md` into organized tasks tied to life goals.

## Process

1. Read `INBOX.md` and `GOALS.md`
2. Classify each item: task, reference note, idea, or unclear
3. Create task files in the appropriate `Tasks/` subdirectory with frontmatter
4. Link every task back to a goal from `GOALS.md`
5. Batch any clarifying questions instead of asking one at a time
6. Clear processed items from `INBOX.md`
7. Summarize what was created — "Created X tasks: Y urgent, Z important, W saved for later"

## Rules

- Every task must connect to a goal. If no goal fits, flag it before creating the task
- Use the user's words for task titles
- Never show YAML or priority codes
- If 10+ items are related, suggest creating a project rather than many loose tasks
