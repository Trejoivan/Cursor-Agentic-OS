# Mini Test Run

This is a mini-bmad ad-hoc run (slug: mini-test-run).

## Where to work

- NOTES.md for ongoing notes
- Add extra artifacts next to it (or create artifacts/)

## Resume / status

From the repo root:

```powershell
.\\scripts\\mini-bmad.ps1 status [run-slug]
.\\scripts\\mini-bmad.ps1 checkpoint [run-slug] -Step [what you just completed / next step]
```

## Link to a major BMAD project (optional)

If this ad-hoc work should update a major project:

```powershell
.\\scripts\\mini-bmad.ps1 link [run-slug] -Project [bmad-project-slug]
.\\scripts\\mini-bmad.ps1 summarize [run-slug] -Sync
```

