# Using agentic-os in Cursor

This repository now has Cursor project rules in `agentic-os/.cursor/rules/`. This workspace also has a parent-level `.cursor/rules/` copy so the rules apply while `C:\Users\trejo\OneDrive\Desktop\cursor_agentic_os` is open in Cursor.

## Quick Start

1. Open `C:\Users\trejo\OneDrive\Desktop\cursor_agentic_os` in Cursor.
2. Pick the OS you want to use:
   - `agentic-os/work-os`
   - `agentic-os/personal-os`
   - `agentic-os/meeting-os`
   - `agentic-os/career-os`
3. Ask Cursor in normal language instead of using Claude slash commands.

Examples:

```text
Help me set up work-os.
What should I work on today?
Process my inbox.
Prepare me for my meeting with Sarah.
Tailor my resume for this job description.
```

## How Cursor Uses the System

Each OS keeps its original `AGENTS.md` as the source of truth. Cursor rules tell the agent to read the right `AGENTS.md`, follow its workflow, and treat the Claude-specific `.claude/skills` and `.claude/agents` files as reference docs.

The old `CLAUDE.md` files are still present so the repository remains compatible with Claude Code, but you do not need to use them in Cursor.

## Cursor Command Mapping

Use natural language prompts:

- `/setup` becomes "Help me set up this OS."
- `/plan-day` becomes "What should I work on today?"
- `/process-inbox` or `/process-backlog` becomes "Process my inbox/backlog."
- `/weekly-review` becomes "Run my weekly review."
- `/prep-meeting` becomes "Help me prepare for [meeting]."
- `/process-meeting` becomes "Process these meeting notes."
- `/tailor-resume` becomes "Tailor my resume for this job description."
- `/prep-interview` becomes "Help me prepare for this interview."

## Safety Defaults

During normal usage, Cursor should write to user-owned work areas such as task, project, knowledge, meeting, career, and archive folders. It should avoid changing templates, docs, examples, and system instructions unless you explicitly ask to customize the OS itself.
