# personal-os Workflows

These files describe specialized workflows the assistant follows for common requests in `personal-os`. They are workflow references — Cursor reads them progressively when the matching intent comes up. There are no slash commands; the user simply phrases the request in natural language and Cursor executes the matching workflow below.

## Map

| Intent | Workflow file |
|--------|---------------|
| "Help me set up personal-os" | `setup.md` |
| "Plan my day" / "What should I work on?" | `daily-planner.md` |
| Add a quick task from a sentence | `add-task.md` |
| "Process my inbox" | `inbox-processor.md` |
| "Weekly review" | `weekly-reviewer.md` |

The Cursor rule at `.cursor/rules/personal-os.mdc` points the assistant at this folder when it needs deeper guidance for a request.
