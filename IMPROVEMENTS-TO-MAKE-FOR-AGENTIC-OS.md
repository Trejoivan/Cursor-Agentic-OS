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

Status key:

- ✅ Resolved
- 🟡 Partially resolved / needs follow-up
- ⏳ Still an improvement to make

### ✅ 1. Add a Root `START-HERE.md`

Resolved. `START-HERE.md` exists and acts as a single entrypoint for the workspace.

### ✅ 2. Add a "Which Layer Should I Use?" Decision Table

Resolved. The decision table is included in `START-HERE.md`.

### ✅ 3. Fix the Core Cursor Rule Glob

Resolved. `.cursor/rules/agentic-os-core.mdc` uses `globs: **/*`.

### ✅ 4. Expand `.gitignore` for All OS User Data

Resolved. The root `.gitignore` includes ignore rules for private user data across `work-os/`, `career-os/`, `personal-os/`, and `meeting-os/` (while keeping templates tracked).

### ✅ 5. Untrack Private Runs and Demo Outputs

Resolved for mini-BMAD runs: `_mini_bmad/runs/` is gitignored and there are no tracked files under `_mini_bmad/runs/`.

Open question (still optional): whether any example BMAD project (e.g. a demo) should live as a tracked example vs an `examples/` area.

### ⏳ 6. Resolve `BACKLOG.md` vs `INBOX.md`

Still an improvement to make.

At minimum, pick one canonical capture vocabulary for `work-os/` (and ensure the docs + workflows consistently refer to the same file name and concept). Right now, the repo uses both “backlog” and “inbox” terminology across OSes.

## Secondary Improvements

### ⏳ Update `README.md`

The root `README.md` should mention:

- `_Bmad/`
- `bmad-projects/`
- `_mini_bmad/`
- `Published/`
- `agentic-db/`
- The privacy model
- The intended relationship between the four OS folders and the BMAD layers

### ⏳ Update `CONTRIBUTING.md`

The current contributing guidance says the repo is markdown-only, but the repo now includes a large BMAD install with code, YAML, skills, and scripts.

Update the contribution guidance to reflect the actual shape of the repo.

### 🟡 Clarify `agentic-db/`

`agentic-db/` is currently useful but isolated.

Choose one of these paths:

- Document it as experimental and optional.
- Integrate it into one or more OS workflows.
- Move it out of the main workspace if it is not part of the current system.

### ⏳ Clean Minor Inconsistencies

- Fix the typo in `.cursor/rules/mini-bmad.mdc` that references `bmad run/.mini-bmad/CHANGES.md`.
- Add missing `.gitkeep` files if `.gitignore` expects them.
- Rename the `.gitignore` header from `work-os .gitignore` to something repo-wide.
- Add a root `AGENTS.md` if you want AI agents to have a top-level operating manual before entering a specific OS folder.

### ✅ Document the `AD_HOC/` layer

Resolved. `AD_HOC/` is now described as the “do the work” layer, with `_mini_bmad/` acting as the summary layer (especially for sync into `bmad-projects/`).

## Suggested Cleanup Order

1. Resolve `BACKLOG.md` vs `INBOX.md`.
2. Update `README.md` and `CONTRIBUTING.md`.
3. Decide (and document) the role of `agentic-db/`.
4. Clean minor inconsistencies (typos, `.gitkeep`, optional root `AGENTS.md`).
5. Decide whether `AD_HOC/` is a first-class layer and document it if so.

## Definition of Done

The workspace should feel complete when:

- A new user can open the repo and know where to start within two minutes.
- An AI agent can quickly decide which folder and workflow to use for a given request.
- Private planning data is ignored by default across all OS folders.
- Public/shareable outputs have one obvious destination: `Published/`.
- Project ideation, daily execution, ad-hoc research, and meeting workflows each have a clear home.
- There is one canonical vocabulary for capture, backlog, inbox, projects, and publishing.
