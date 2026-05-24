# BMAD Projects (consolidated)

This folder is a **single consolidated home for all “major project ideas”** you run through the BMAD process.

## How it works

- Each idea gets its own workspace at `bmad-projects/<project-slug>/`.
- That workspace **reuses the one BMAD install in this repo** (under `_Bmad/`) by creating *junctions* inside the project folder:
  - `_bmad` → `_Bmad/_bmad` (BMAD engine + config + scripts)
  - `.agents` → `_Bmad/.agents` (BMAD skills)
- Because BMAD skills resolve `{project-root}` to the folder you’re working in, **all outputs land inside that project folder** (ex: `bmad-projects/<slug>/_bmad-output/...`).

## Common commands (Windows / PowerShell)

Create a new BMAD project workspace:

```powershell
.\scripts\bmad-project.ps1 new "My Project Idea"
```

Open an existing project workspace:

```powershell
.\scripts\bmad-project.ps1 open "my-project-idea"
```

Save a “resume point” (last place you left off):

```powershell
.\scripts\bmad-project.ps1 checkpoint "my-project-idea" -Step "PRFAQ Stage 3 (Customer FAQ) drafted"
```

View saved status:

```powershell
.\scripts\bmad-project.ps1 status "my-project-idea"
```

List projects:

```powershell
.\scripts\bmad-project.ps1 list
```

## Resume behavior

Many BMAD skills also have **built-in resume detection** when they see existing artifacts in your project’s `_bmad-output/` folder. So even without a manual checkpoint, rerunning the same skill in the same project workspace often resumes automatically.

Each project workspace also gets a `START-HERE.md` file created automatically so you have a single entrypoint that links to outputs and your saved checkpoint.

