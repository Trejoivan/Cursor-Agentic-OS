
# agentic-os: AI-Native Operating Systems Powered by Cursor

> Stop managing tools. Start having conversations. Let AI manage the system while you do the work.

A collection of markdown-based operating systems where AI handles the structure, organization, and context so you can focus on what matters. Each OS is self-contained, local-first, and runs entirely inside [Cursor](https://cursor.com) using `AGENTS.md` and project rules.

## About This Fork

This repo is my attempt to convert a pre-existing **Claude Code** “agentic OS” style process into **my own Cursor-compatible OS workflow** (local-first markdown + `AGENTS.md` + `.cursor/rules`). Expect iteration as I adapt the ideas to how Cursor actually operates.

## What Is an Agentic OS?

An agentic OS is a folder of markdown files plus a set of Cursor rules and workflows that turn Cursor into a specialized assistant. No databases, no SaaS, no vendor lock-in. Your data lives as plain text on your machine. Cursor reads your instructions, understands your context, and manages the system through conversation.

You talk. It organizes. You keep working.

## The Collection

| OS | What It Does | Who It's For |
|---|---|---|
| **[work-os](work-os/)** | Professional task management, goal tracking, daily planning | Knowledge workers managing professional tasks, goals, and career growth |
| **[career-os](career-os/)** | Resume tailoring, STAR stories, interview prep, application tracking | Job seekers who want a full system for landing their next role |
| **[personal-os](personal-os/)** | Life goals, relationships, health, projects, finances | Anyone wanting a structured system for managing their whole life |
| **[meeting-os](meeting-os/)** | Meeting notes, decision tracking, action items, follow-ups | Professionals who lose track of what happened and what was promised |

Each OS works independently. Pick one, pick all four, or mix and match.

## Philosophy

- **Local-first.** Everything is markdown files on your machine. Back up to GitHub if you want, but nothing leaves your computer by default.
- **Conversational.** No forms, no fields, no clicks. You talk to Cursor in natural language and it handles the rest.
- **Goal-driven.** Every task, note, and action connects back to what you're trying to accomplish. Cursor keeps you aligned.
- **No vendor lock-in.** It's just markdown. If you stop using Cursor tomorrow, your files are still useful, readable text.
- **Progressive context.** Cursor loads only what it needs, when it needs it. Small instruction files (`AGENTS.md`) point to deeper docs and workflows on demand.

## Getting Started

1. Install [Cursor](https://cursor.com) if you don't already have it.

2. Clone the collection:

   ```bash
   git clone https://github.com/ahmadelswify/agentic-os.git
   ```

3. Open the cloned `agentic-os/` folder (or its parent) in Cursor. The Cursor rules in `agentic-os/.cursor/rules/` attach automatically.

4. Pick an OS, open a file inside it, and start a chat:

   ```text
   What should I work on today?
   Process my inbox.
   Tailor my resume for this job description.
   ```

See [CURSOR.md](CURSOR.md) for the full setup walkthrough and the natural-language prompts each OS responds to.

## AD_HOC → mini-bmad → BMAD (recommended process)

This repo supports a simple “do the work → summarize → course-correct” loop:

- **Do one concrete task in `AD_HOC/`**: drafts, meeting artifacts, analysis, notes. Keep outcomes private-by-default; publish only curated results to `Published/`.
- **Summarize with `_mini_bmad/` when needed**: use mini-bmad runs as a **summary layer** (day/week/multi-week) and optionally sync summaries into a major BMAD project.
- **Course-correct with `bmad-projects/` when decisions change scope**: if ad-hoc work results in official decisions (new constraints, scope changes, strategy shifts), update the BMAD project so the “source of truth” stays aligned.

If you’re unsure where to start, open `START-HERE.md`.

## Contributing

Found this helpful? Have ideas? Open an issue or PR. Each OS accepts contributions independently.

If you build your own agentic OS and want to add it to the collection, open a PR with a new subdirectory following the same structure: `README.md`, `AGENTS.md`, `workflows/`, and supporting files.

## License

MIT. Use it however you want.
