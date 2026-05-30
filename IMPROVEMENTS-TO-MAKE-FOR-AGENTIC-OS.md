# Improvements to Make for Agentic OS

Goal: make this workspace easy to follow, strong for interactive AI planning and development, and cleanly confined for all use cases.

## Current Shape

The repo currently has three main layers:

1. **Markdown OS folders**: `work-os/`, `career-os/`, `personal-os/`, and `meeting-os/`.
2. **BMAD project layer**: `_Bmad/`, `bmad-projects/`, and `_mini_bmad/`.
3. **Optional persistence layer**: `agentic-db/`.

The per-OS folders are generally well structured. Each has a predictable pattern using `README.md`, `AGENTS.md`, templates, workflows, and matching Cursor rules.

The main friction is that the repo has grown beyond the original four-OS model, but the root documentation still mostly explains only those four OSes. The BMAD, mini-BMAD, publishing, and database layers are useful, but they are not yet easy to discover from the top level.

## What Is Working Well

- The four OS folders have a consistent structure that is easy for both users and AI agents to understand.
- `work-os/` is especially strong, with setup docs, examples, architecture notes, tutorials, workflows, and validation guidance.
- The Cursor rules provide useful routing behavior for different areas of the workspace.
- The BMAD workspace approach avoids copying the whole BMAD install into every project.
- `_mini_bmad/` is a good lightweight layer for ad-hoc research, meeting prep, presentation planning, and temporary work.
- `Published/` gives the repo a clear place for sanitized, shareable outputs.

## Priority Improvements

### 1. Add a Root `START-HERE.md`

Create a single entrypoint that explains the whole workspace:

- What Agentic OS is.
- What each top-level folder is for.
- How the four OS folders relate to BMAD, mini-BMAD, `Published/`, and `agentic-db/`.
- What should be private by default.
- What should be shareable or publishable.
- How a user should start depending on their goal.

This is the highest-impact improvement because it gives both humans and AI agents a reliable map before they start exploring.

### 2. Add a "Which Layer Should I Use?" Decision Table

Add a simple decision table to the root docs.

Suggested routing:

| User Intent | Best Place |
| --- | --- |
| Daily professional planning | `work-os/` |
| Job search, resume, interviews | `career-os/` |
| Personal planning and life admin | `personal-os/` |
| Meeting prep, notes, decisions, actions | `meeting-os/` |
| Major product, app, business, or workflow idea | `bmad-projects/` |
| Quick research, brainstorm, meeting plan, or presentation outline | `_mini_bmad/` |
| Curated artifact to share | `Published/` |
| Experimental structured storage | `agentic-db/` |

This matters because the repo currently has multiple project-like concepts: `work-os/Projects/`, `personal-os/Projects/`, and `bmad-projects/`.

### 3. Fix the Core Cursor Rule Glob

The rule file `.cursor/rules/agentic-os-core.mdc` uses a glob that may not attach when this repo is opened directly in Cursor.

Recommended change:

```md
globs: **/*
```

This ensures the core Agentic OS behavior applies throughout the workspace.

### 4. Expand `.gitignore` for All OS User Data

The root `.gitignore` currently protects many `work-os/` user-data directories, but it does not appear to protect equivalent user data in `career-os/`, `personal-os/`, and `meeting-os/`.

Add ignore rules for private user artifacts such as:

- `career-os/Applications/`
- `career-os/Impact-Library/`
- `career-os/Interview-Prep/`
- `personal-os/Tasks/`
- `personal-os/Projects/`
- `personal-os/Knowledge/`
- `meeting-os/Meetings/`
- `meeting-os/People/`
- `meeting-os/Actions/`

Keep templates, examples, docs, and workflow files tracked.

### 5. Untrack Private Runs and Demo Outputs

Some `_mini_bmad/runs/` files appear to be tracked even though that folder is now intended to be private and ignored.

Recommended cleanup:

- Remove tracked mini-BMAD run artifacts from git history going forward with `git rm --cached`.
- Keep `_mini_bmad/templates/`, `_mini_bmad/README.md`, and `_mini_bmad/AGENTS.md` tracked.
- Decide whether `bmad-projects/demo-bmad-project/` should remain as a real example or move into an explicit `examples/` area.

### 6. Resolve `BACKLOG.md` vs `INBOX.md`

`work-os/` currently has inconsistent capture terminology. Some docs refer to `BACKLOG.md`; others refer to `INBOX.md`.

Pick one canonical name and update all docs and workflows to match.

Suggested default:

- Use `BACKLOG.md` if the workspace is intended to feel like project/task management.
- Use `INBOX.md` if the workspace is intended to feel like capture-first GTD.

The important part is consistency so AI agents do not create or read the wrong file.

## Secondary Improvements

### Update `README.md`

The root `README.md` should mention:

- `_Bmad/`
- `bmad-projects/`
- `_mini_bmad/`
- `Published/`
- `agentic-db/`
- The privacy model
- The intended relationship between the four OS folders and the BMAD layers

### Update `CONTRIBUTING.md`

The current contributing guidance says the repo is markdown-only, but the repo now includes a large BMAD install with code, YAML, skills, and scripts.

Update the contribution guidance to reflect the actual shape of the repo.

### Clarify `agentic-db/`

`agentic-db/` is currently useful but isolated.

Choose one of these paths:

- Document it as experimental and optional.
- Integrate it into one or more OS workflows.
- Move it out of the main workspace if it is not part of the current system.

### Clean Minor Inconsistencies

- Fix the typo in `.cursor/rules/mini-bmad.mdc` that references `bmad run/.mini-bmad/CHANGES.md`.
- Add missing `.gitkeep` files if `.gitignore` expects them.
- Rename the `.gitignore` header from `work-os .gitignore` to something repo-wide.
- Add a root `AGENTS.md` if you want AI agents to have a top-level operating manual before entering a specific OS folder.

## Suggested Cleanup Order

1. Create root `START-HERE.md`.
2. Add the "Which Layer Should I Use?" decision table.
3. Fix `.cursor/rules/agentic-os-core.mdc`.
4. Expand `.gitignore` for all private OS user data.
5. Untrack existing private mini-BMAD runs.
6. Resolve `BACKLOG.md` vs `INBOX.md`.
7. Update `README.md` and `CONTRIBUTING.md`.
8. Decide the role of `agentic-db/`.

## Definition of Done

The workspace should feel complete when:

- A new user can open the repo and know where to start within two minutes.
- An AI agent can quickly decide which folder and workflow to use for a given request.
- Private planning data is ignored by default across all OS folders.
- Public/shareable outputs have one obvious destination: `Published/`.
- Project ideation, daily execution, ad-hoc research, and meeting workflows each have a clear home.
- There is one canonical vocabulary for capture, backlog, inbox, projects, and publishing.
