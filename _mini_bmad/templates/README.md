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

