# bmad_prep/ (landing zone for BMAD-prep summaries)

This folder is a simple inbox/outbox for **BMAD-prep** (BMAD ingest–ready) summaries produced elsewhere (for example from transcript summaries).

## Folders

- `pending/` — new BMAD-prep files waiting to be synced into a BMAD project
- `done_prep_bmad/` — files already used for a BMAD update (moved here to prevent re-running)

## Recommended flow

1. Generate BMAD-prep summaries (for example using `/bmadprep`).
2. Drop/copy the resulting `*-bmad-prep.md` into `pending/`.
3. Sync into a BMAD project (moves the used files into `done_prep_bmad/`):

```powershell
.\scripts\mini-bmad.ps1 bmadprep-sync -Project "<bmad-project-slug>"
```

