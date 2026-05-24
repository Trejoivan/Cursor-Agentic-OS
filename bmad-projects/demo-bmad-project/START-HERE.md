# demo-bmad-project

This is the consolidated BMAD workspace for **demo-bmad-project** ($Slug).

## Where things go

- BMAD outputs (generated): _bmad-output/
- Resume state / checkpoints: .bmad/state.json
- Shared BMAD engine (junction): _bmad/
- Shared BMAD skills (junction): .agents/

## Resume quickly

From the repo root:

`powershell
.\scripts\bmad-project.ps1 status "demo-bmad-project"
.\scripts\bmad-project.ps1 checkpoint "demo-bmad-project" -Step "<what you just completed / next step>"
`

## Suggested workflow

- Keep your project notes, drafts, and artifacts in this folder (alongside this file).
- Run BMAD skills from within this workspace so {project-root} resolves here and outputs stay consolidated.
