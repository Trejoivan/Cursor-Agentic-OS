# work-os Workflows

These files describe specialized workflows the assistant follows for common requests in `work-os`. They are workflow references — Cursor reads them progressively when the matching intent comes up. There are no slash commands; the user simply phrases the request in natural language (for example, "plan my day" or "process my backlog") and Cursor executes the matching workflow below.

## Map

| Intent | Workflow file |
|--------|---------------|
| "Help me set up work-os" | `setup.md` |
| "Plan my day" / "What should I work on?" | `daily-planner.md` |
| Add a quick task from a sentence | `add-task.md` |
| "Process my backlog" / brain dump cleanup | `backlog-processor.md` |
| "Weekly review" | `weekly-reviewer.md` |
| "Prep me for a meeting" | `prep-meeting.md` |
| "Process these meeting notes" | `meeting-processor.md` |
| "Log this accomplishment" | `career-tracker.md` |
| "Create a new project" / "I have a project idea" / "Update project context" | `project-intake.md` |
| "Generate a status report" | `project-reporter.md` |

The Cursor rule at `.cursor/rules/work-os.mdc` points the assistant at this folder when it needs deeper guidance for a request.
