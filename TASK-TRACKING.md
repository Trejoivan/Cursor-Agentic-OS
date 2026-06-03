# Repo-wide task tracking (ad-hoc / one-off)

This repo already supports **ad-hoc work** via `_mini_bmad/` runs (with `delta` summaries that clear pending changes).

This document covers the **repo-wide** tracker for *any* one-off tasks you run or want to record, across all folders.

## Quick start (PowerShell)

Log a task (no command execution):

```powershell
.\scripts\task-ledger.ps1 log -What "Did a quick investigation on X"
```

Run a one-off command *and* log it:

```powershell
.\scripts\task-ledger.ps1 run -What "Regenerate something" -Cmd "git status"
```

Generate a grouped summary **and reset** tracking for the next cycle:

```powershell
.\scripts\task-ledger.ps1 summarize
```

## Auto-grouping (projects)

If you don’t pass `-Project`, the tracker infers a group from your current working directory:

- `bmad-projects/<slug>/...` → `bmad:<slug>`
- `_mini_bmad/runs/.../<run-id>/...` → `mini:<run-id>`
- `work-os/`, `career-os/`, `personal-os/`, `meeting-os/` → `os:<folder>`
- otherwise → top-level folder name (or `repo-root`)

You can always override:

```powershell
.\scripts\task-ledger.ps1 log -What "Kickoff notes" -Project "client:acme"
```

## Where the data lives

Local-first files under:

- `.task-ledger/ledger.jsonl`: current “since last summary” entries
- `.task-ledger/summary/LAST-SUMMARY.md`: most recent summary
- `.task-ledger/archive/`: archived ledgers after each summary

`.task-ledger/` is gitignored by default.

