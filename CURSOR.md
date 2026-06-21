# Using agentic-os in Cursor

This repository is designed to run entirely inside [Cursor](https://cursor.com). Project rules in `agentic-os/.cursor/rules/` (and a parent-level copy in this workspace's `.cursor/rules/`) make Cursor read each OS's `AGENTS.md` and follow the matching workflows automatically.

## Quick Start

1. Install [Cursor](https://cursor.com).
2. Clone the repo and open the folder in Cursor:

   ```bash
   git clone https://github.com/ahmadelswify/agentic-os.git
   ```

3. Pick the OS you want to use:
   - `agentic-os/work-os`
   - `agentic-os/personal-os`
   - `agentic-os/meeting-os`
   - `agentic-os/career-os`

4. Open a file inside that OS folder so Cursor's chat picks up the matching rule, then ask in natural language.

Examples:

```text
Help me set up work-os.
What should I work on today?
Process my inbox.
Prepare me for my meeting with Sarah.
Tailor my resume for this job description.
```

## How Cursor Uses the System

Each OS has a single `AGENTS.md` that acts as the source of truth. The Cursor rule in `.cursor/rules/<os>.mdc` keeps that file at the top of context whenever you're working inside that OS, and the rule itself summarizes the do's and don'ts so Cursor stays on guardrails.

Specialized workflows live in `<os>/workflows/`. When you ask something like "process my backlog" or "tailor my resume", Cursor looks up the matching workflow file (for example `workflows/backlog-processor.md`) and follows those steps. Deeper reference docs live in `<os>/docs/` and are loaded on demand.

There are no slash commands. Cursor recognizes natural-language intents directly.

## Optional prompt suffix directives (quality-of-life)

In addition to natural language, you can optionally add **end-of-prompt directives** to tell the agent what *kind* of output you want, without sending a second prompt. These are not “workflows” — they’re post-processing/output hints.

Examples:

```text
Draft an agenda for my vendor call tomorrow /cag /smd
Summarize this PDF and extract action items /rag /smd
Summarize these notes and give me next steps /sum /next
Extract action items and save them /todo /smd
Write a concise status email to stakeholders based on this update /email=status /smd
Turn this into step-by-step instructions /fmt=steps /smd
```

Supported directives:

- **`/smd`**: save the main output as a `.md` file (defaults under `AD_HOC/workspace/outputs/`)
- **`/fmt`**: force the output format (e.g. `/fmt=bullets`, `/fmt=checklist`, `/fmt=steps`)
- **`/email`**: draft the output as an email (e.g. `/email=follow-up`, `/email=request`, `/email=status`)
- **`/cag`**: create a meeting agenda file (defaults under `meeting-os/Meetings/.../AGENDA.md`)
- **`/rag`**: add a short “review as agent” pass (gaps, risks, next steps)
- **`/sum`**: force a tight summary format (short bullets, action items, open questions)
- **`/todo`**: extract action items as a checklist (and save alongside if not already saving)
- **`/next`**: end with ordered next steps
- **`/tlog`**: log a one-line completion note to `scripts/task-ledger.ps1`

## Common Prompts by OS

### work-os

- "Help me set up work-os."
- "What should I work on today?"
- "Process my backlog."
- "Run my weekly review."
- "Add a task: …"
- "Prep me for my meeting with [name]."
- "Log this accomplishment: …"
- "Generate a status report for [project]."

### personal-os

- "Help me set up personal-os."
- "What should I work on today?"
- "Process my inbox."
- "Run my weekly review."
- "Add a task: …"

### meeting-os

- "Help me set up meeting-os."
- "Process these meeting notes: …"
- "Prep me for my meeting with [name]."

### career-os

- "Help me set up career-os."
- "Tailor my resume for this job description: …"
- "Help me prep for this interview."
- "Log the outcome from [company]."

## Safety Defaults

During normal usage, Cursor should write to user-owned work areas such as task, project, knowledge, meeting, career, and archive folders. It should avoid changing templates, docs, examples, and system instructions unless you explicitly ask to customize the OS itself. The Cursor rules call this out for each OS so the agent treats `templates/`, `docs/`, `tutorials/`, `use-cases/`, `workflows/`, and `AGENTS.md` as read-only during day-to-day work.
