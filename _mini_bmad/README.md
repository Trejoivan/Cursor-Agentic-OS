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

Mini-bmad can also serve as a **summary layer** for ad-hoc work you did elsewhere in the repo (for example under `AD_HOC/`), especially when:

- you want a day/week/multi-week consolidation window
- you want to sync learnings/decisions back into a major BMAD project

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
- `summary/BMAD-DAILY-BRIEF.md` (single-file BMAD update)

### Default run folders

New runs are scaffolded with a small set of folders so you can keep ad-hoc work organized:

- `meeting/`: agenda, attendees, decisions
- `prep/`: checklists, questions, pre-reads
- `analysis/`: structured options/trade-offs/recommendation
- `refinements/`: iterative rewrites / versions
- `summary/`: human-written summary draft (separate from generated outputs)
- `links/`: quick links list
- `notes/`: extra scratch notes (in addition to top-level `NOTES.md`)
- `artifacts/`: supporting drafts/exports/diagrams
- `_promote-templates/`: drop `.md` / `.txt` files here to save as reusable templates on `summarize`

Outputs:

- Consolidated “summary pack”: `_mini_bmad/runs/<run>/_mini-summary/SUMMARY-PACK.md`
- Very short delta: `_mini_bmad/runs/<run>/_mini-summary/DELTA-SINCE-LAST.md`
- Sync payloads into BMAD projects: `bmad-projects/<slug>/_mini-bmad-updates/<run-id>.md`

## Single-file format for feeding BMAD daily (recommended)

If you want **one file** BMAD can ingest for course-correction, scope changes, confirmations, and new constraints, use:

- `summary/BMAD-DAILY-BRIEF.md`

It’s intentionally written in a **distillate-style** (dense bullets + light YAML header) so it can serve as:

- a “what changed since last time” delta
- a decision/confirmation log
- an impact hint list (PRD/Epics/Architecture/UX)
- a compact set of open questions and next actions

### Daily loop

- Do the work (notes/artifacts) inside the run.
- Update `summary/BMAD-DAILY-BRIEF.md` during/after the session.
- When you want to push the update into a major BMAD project, link + sync:

```powershell
.\scripts\mini-bmad.ps1 link "<run-slug>" -Project "<bmad-project-slug>"
.\scripts\mini-bmad.ps1 brief "<run-slug>" -Sync
```

Use `summarize -Sync` when you want the full consolidated pack synced (heavier).

## Single-file format for feeding BMAD weekly (recommended)

For a weekly consolidation that BMAD can use to course-correct (net scope/constraint changes + impacts + next-week focus), use:

- `summary/BMAD-WEEKLY-BRIEF.md`

### Weekly loop (recommended)

- Keep **daily runs** for daily work + daily briefs.
- Create a **weekly run** (one per week) for consolidation, then sync just the weekly brief:

```powershell
.\scripts\mini-bmad.ps1 new "Weekly brief - <week label>"
# edit summary/BMAD-WEEKLY-BRIEF.md inside that run
.\scripts\mini-bmad.ps1 link "<weekly-run-slug>" -Project "<bmad-project-slug>"
.\scripts\mini-bmad.ps1 weekly "<weekly-run-slug>" -Sync
```

