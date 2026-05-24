# BMAD Projects (consolidated)

This folder is the **single home for major project ideas** you want to run through the BMAD process, without copying BMAD into each project.

## The key idea

- Each project gets a workspace at `bmad-projects/<project-slug>/`.
- That workspace reuses the repo’s shared BMAD install via junctions:
  - `_bmad` → `_Bmad/_bmad`
  - `.agents` → `_Bmad/.agents`
- BMAD outputs remain **scoped to the project** (typically under `_bmad-output/`), so you can pause and resume cleanly.

## Create / open a project

From the repo root:

```powershell
.\scripts\bmad-project.ps1 new "My Project Idea"
.\scripts\bmad-project.ps1 open "my-project-idea"
```

## Resume / remember where you left off

- View status:

```powershell
.\scripts\bmad-project.ps1 status "my-project-idea"
```

- Save a checkpoint:

```powershell
.\scripts\bmad-project.ps1 checkpoint "my-project-idea" -Step "PRFAQ Stage 3 drafted"
```

The saved state lives in `bmad-projects/<slug>/.bmad/state.json`.

## Where to work

- Start in `bmad-projects/<slug>/START-HERE.md` (created automatically).
- Keep project-specific notes, drafts, and artifacts **inside that project folder**.
- Avoid editing `bmad-projects/<slug>/_bmad` and `bmad-projects/<slug>/.agents` directly (they’re shared junctions).

