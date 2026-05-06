# career-os Workflows

These files describe specialized workflows the assistant follows for common requests in `career-os`. They are workflow references — Cursor reads them progressively when the matching intent comes up. There are no slash commands; the user simply phrases the request in natural language and Cursor executes the matching workflow below.

## Map

| Intent | Workflow file |
|--------|---------------|
| "Help me set up career-os" | `setup.md` |
| "Tailor my resume for this job description" | `resume-tailor.md` |
| "Help me prep for this interview" | `interview-coach.md` |
| "Log this outcome" | `log-outcome.md` |

The Cursor rule at `.cursor/rules/career-os.mdc` points the assistant at this folder when it needs deeper guidance for a request.
