# meeting-os Workflows

These files describe specialized workflows the assistant follows for common requests in `meeting-os`. They are workflow references — Cursor reads them progressively when the matching intent comes up. There are no slash commands; the user simply phrases the request in natural language and Cursor executes the matching workflow below.

## Map

| Intent | Workflow file |
|--------|---------------|
| "Help me set up meeting-os" | `setup.md` |
| "Process these meeting notes" | `meeting-processor.md` |
| "Prep me for [meeting]" | `meeting-prepper.md` |

The Cursor rule at `.cursor/rules/meeting-os.mdc` points the assistant at this folder when it needs deeper guidance for a request.
