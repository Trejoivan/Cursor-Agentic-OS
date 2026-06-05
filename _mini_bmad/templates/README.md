# Templates

This folder contains reusable templates captured from mini-bmad runs.

## How to add templates automatically

Inside a run folder, put any candidate templates you want to save into:

- `_promote-templates/`

Then run:

```powershell
.\scripts\mini-bmad.ps1 summarize "<run-slug>"
```

Any `.md` / `.txt` files in `_promote-templates/` get copied into `_mini_bmad/templates/` and listed in the generated summary pack.

## Suggested default template: BMAD Daily Brief

If you want a **single-file, BMAD-ingestable** daily update format (decisions, scope changes, constraints, open questions, and next actions), use:

- `bmad-daily-brief.md`

## Suggested default template: BMAD Weekly Brief

If you also want a **single-file weekly consolidation** (net changes + impacts + next-week focus), use:

- `bmad-weekly-brief.md`

