# _mini_bmad (ad-hoc runs)

Use `_mini_bmad/` for quick, one-off work that should still be **capturable, resumable, and easy to consolidate**.

## What counts as mini-bmad?

- Research spikes / investigation notes
- Meeting planning (agenda, attendee list, questions, decisions)
- Presentation brainstorming (outline, key messages, slide plan)
- “One-off” analysis you may want to apply back to a major project later

## Workflow

1. Create/open a run (from repo root):

```powershell
.\scripts\mini-bmad.ps1 new "Some ad-hoc topic"
.\scripts\mini-bmad.ps1 open "some-ad-hoc-topic"
```

2. Work inside the run folder:
   - `START-HERE.md` for orientation
   - `NOTES.md` for ongoing notes
   - Use the scaffold folders as needed:
     - `meeting/`, `prep/`, `analysis/`, `refinements/`, `summary/`, `links/`, `notes/`, `artifacts/`
     - `_promote-templates/` to save `.md` / `.txt` files as reusable templates on `summarize`

3. When ready, consolidate:

```powershell
.\scripts\mini-bmad.ps1 summarize "some-ad-hoc-topic"
```

4. If the run should update one or more major BMAD projects, link it and sync:

```powershell
.\scripts\mini-bmad.ps1 link "some-ad-hoc-topic" -Project "my-major-project"
.\scripts\mini-bmad.ps1 summarize "some-ad-hoc-topic" -Sync
```

## State / resume

Each run keeps lightweight state in `.mini-bmad/state.json`, including:

- `lastCheckpoint` (where you left off)
- `linkedProjects` (BMAD project slugs to receive sync updates)

