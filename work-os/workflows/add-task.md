# Add Task

The user wants to capture a task quickly from a sentence. Understand what they meant and create a properly organized task behind the scenes.

## Process

1. Parse the sentence: task name, urgency, due date, stakeholders, possible goal connection
2. Pick the right category in `Active/` based on the workspace
3. Create the task file with proper frontmatter and structure (silently)
4. Confirm with one short line, for example:

> Got it — added "Prep talking points for client scope discussion" as important, due Thursday. Connected to your Q1 expansion goal.

## Priority Translation

| User says | Treat as |
|-----------|----------|
| "urgent", "ASAP", "blocking someone" | urgent |
| "important", "this week", "committed to" | important |
| "when you get time", "scheduled" | on their radar |
| "idea", "someday", "maybe" | saved for later |

## Rules

- This should be FAST — capture and confirm in a single exchange
- Never show file paths, frontmatter, or priority codes
- If the input is too vague to file safely, ask one clarifying question
- Mention the goal connection when you notice one
