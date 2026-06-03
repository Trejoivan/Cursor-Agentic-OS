# START HERE (Agentic OS)

This repo is a local-first “operating system” made of markdown folders + Cursor rules. It’s designed to be easy for you (and an AI agent) to navigate without guessing where things belong.

## The One-Minute Map

There are three layers:

- **Daily life + work systems (4 OSes)**: `work-os/`, `career-os/`, `personal-os/`, `meeting-os/`
- **Big-idea / product / system planning (BMAD)**: `_Bmad/`, `bmad-projects/`, `_mini_bmad/`
- **Optional structured storage**: `agentic-db/` (experimental)

If you’re unsure, start with the decision table below.

## Which Layer Should I Use?

| Your intent | Use this | Why |
| --- | --- | --- |
| Plan my day, manage professional tasks, track work goals | `work-os/` | Your main execution system for professional work |
| Job search: resume tailoring, interview prep, applications | `career-os/` | Purpose-built job search workflows and artifacts |
| Personal planning: health, relationships, life admin, finances, personal projects | `personal-os/` | Personal “whole-life” execution system |
| Meeting prep + notes + decisions + follow-ups | `meeting-os/` | Dedicated meeting capture + action tracking |
| A major new product/app/business/workflow idea | `bmad-projects/` | Structured ideation + planning workspace (BMAD) |
| Do one concrete ad-hoc task (draft, analyze, prep) | `AD_HOC/` | Lightweight workspace + predictable folders for “do the work” |
| Ad-hoc research, meeting planning, presentation outlines, one-off investigations | `_mini_bmad/` | Fast temporary “run” workflow with summaries |
| I want to share an output publicly (sanitized) | `Published/` | Curated, shareable artifacts live here |
| I want a database-backed record store | `agentic-db/` | Optional Postgres JSON store (not required) |

## How to Start (Recommended)

### Daily usage

1. Pick the OS you want (usually `work-os/`).
2. Open any file inside that folder so Cursor picks up the matching rule.
3. Ask in natural language.

Examples:

```text
Help me set up work-os.
What should I work on today?
Process my inbox / backlog.
Run my weekly review.
Prep me for my meeting with Alex.
```

See `CURSOR.md` for more prompt examples.

### Major project / new idea (BMAD projects)

Use a project workspace under `bmad-projects/<project-slug>/`.

From PowerShell in the repo root:

```powershell
.\scripts\bmad-project.ps1 new "My Project Name"
.\scripts\bmad-project.ps1 open "my-project-name"
```

Each BMAD project keeps its own `START-HERE.md` and state under `bmad-projects/<slug>/`.

### Quick research / meeting plan / one-off (mini-bmad runs)

Use a run under `_mini_bmad/runs/...`.

```powershell
.\scripts\mini-bmad.ps1 new "Research topic"
.\scripts\mini-bmad.ps1 summarize "<run-slug>"
```

Mini-bmad runs are private by default and can optionally sync summaries into a BMAD project.

### Ad-hoc task → mini-bmad summary → BMAD course-correct (recommended process)

- Do the hands-on work in `AD_HOC/` (drafts, notes, analysis, meeting artifacts).
- When you want consolidation (day/week/multi-week) and/or you want to sync into a major BMAD project, create/open a mini-bmad run and use `summarize` / `delta` as the **summary layer**.
- If the ad-hoc work produced official decisions that change scope or constraints, update the relevant BMAD project so the “source of truth” stays aligned.

### Track ad-hoc tasks repo-wide (summarize + reset)

If you want a lightweight “what did I do?” log across *any* folder in this repo, use:

```powershell
.\scripts\task-ledger.ps1 log -What "Did X"
.\scripts\task-ledger.ps1 run -What "Did Y" -Cmd "some command here"
.\scripts\task-ledger.ps1 summarize
```

See `TASK-TRACKING.md` for details.

## The Folder Guide

- **`work-os/`**: professional execution system (planning, tasks, goals, projects)
- **`career-os/`**: job search system (resume tailoring, interview prep, applications)
- **`personal-os/`**: personal execution system (life admin, goals, personal projects)
- **`meeting-os/`**: meeting system (prep, notes, decisions, actions, people)
- **`_Bmad/`**: shared BMAD install (large; used via junctions by projects)
- **`bmad-projects/`**: per-idea workspaces (private by default / gitignored)
- **`_mini_bmad/`**: ad-hoc runs (private by default / gitignored)
- **`Published/`**: intentionally shareable artifacts
- **`agentic-db/`**: optional Postgres store (experimental)
- **`.cursor/rules/`**: Cursor rules that keep the right `AGENTS.md` and workflows in context
- **`scripts/`**: PowerShell helpers for BMAD projects and mini-bmad runs

## Operating Principle (for humans + AI)

Within an OS folder, treat `AGENTS.md` as the primary operating manual. Workflows live in `<os>/workflows/`. Deeper reference docs live in `<os>/docs/`.

During normal usage, avoid editing harness/system files (templates, docs, workflows, rules) unless you’re explicitly customizing the OS itself.

