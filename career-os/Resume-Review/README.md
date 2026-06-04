# Resume Review & Modifier

This workspace is for **reviewing, refining, and tailoring resumes** with clear “drop zones” for inputs and outputs.

## Folder map

- `inputs/resumes/`: drop your **master resume** files here (PDF/DOCX/MD/TXT)
- `inputs/job-postings/`: drop **job descriptions** here (TXT/MD/PDF exports, etc.)
- `outputs/refined/`: the improved/refined resume outputs
- `outputs/tailored/`: resumes tailored to a specific job posting (one subfolder per listing)
- `recommendations/`: job recommendations and tracking (based on your resume)
- `templates/`: reusable templates for job postings, recommendations, and review notes

## Recommended flow

1. Drop your latest master resume in `inputs/resumes/`.
2. Ask for a resume review/refinement; save the updated version to `outputs/refined/`.
3. When you have a job description, drop it in `inputs/job-postings/` and generate a tailored version under `outputs/tailored/<company>-<role>/`.
4. Track suggested roles/jobs in `recommendations/` (and promote anything you actually apply to into `Applications/`).

## Privacy model

Only the scaffold (folders + READMEs/templates) is intended to be committed.
Your actual resume files, job postings, and tailored outputs are gitignored by default.

