# _mini_bmad (ad-hoc workbench)

`_mini_bmad/` is for **one-off, ad-hoc work** that you still want to keep organized and easy to summarize:

- Research spikes / quick investigations
- Meeting planning and agendas
- Presentation brainstorming and outlines
- “Scratchpad” decisions you might want to apply back to a major BMAD project later

## The model

- Each ad-hoc effort becomes a **run** folder under `_mini_bmad/runs/`.
- A run is lightweight: notes + artifacts + a small state file that records your last checkpoint and any linked BMAD projects.
- While you work, you keep a **very short “pending changes” list** in `.mini-bmad/CHANGES.md`.
- When you’re ready, you can:
  - run **delta** to summarize *only the work since your last delta summary* (very short bullets) and clear pending changes
  - run **summarize** to produce a consolidated “summary pack” (full collated artifacts)

## Common commands (Windows / PowerShell)

Create a new mini run:

```powershell
.\scripts\mini-bmad.ps1 new "Customer meeting prep - ACME"
```

Open an existing run:

```powershell
.\scripts\mini-bmad.ps1 open "customer-meeting-prep-acme"
```

Checkpoint your place:

```powershell
.\scripts\mini-bmad.ps1 checkpoint "customer-meeting-prep-acme" -Step "Agenda drafted; questions list v2"
```

Link the run to a major BMAD project (so summaries can sync back):

```powershell
.\scripts\mini-bmad.ps1 link "customer-meeting-prep-acme" -Project "my-major-project"
```

Summarize (and sync into linked BMAD projects):

```powershell
.\scripts\mini-bmad.ps1 summarize "customer-meeting-prep-acme" -Sync
```

Track a short “event / item changed” (adds one bullet to `.mini-bmad/CHANGES.md`):

```powershell
.\scripts\mini-bmad.ps1 log "customer-meeting-prep-acme" -Item "Added 5 agenda topics + desired outcomes"
```

Very short summary since last delta (clears pending changes; optional sync):

```powershell
.\scripts\mini-bmad.ps1 delta "customer-meeting-prep-acme" -Sync
```

## Where to start inside a run

Open the run folder and start with:

- `START-HERE.md`
- `NOTES.md`

Outputs:

- Consolidated “summary pack”: `_mini_bmad/runs/<run>/_mini-summary/SUMMARY-PACK.md`
- Very short delta: `_mini_bmad/runs/<run>/_mini-summary/DELTA-SINCE-LAST.md`
- Sync payloads into BMAD projects: `bmad-projects/<slug>/_mini-bmad-updates/<run-id>.md`

