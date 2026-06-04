# Resume review & modifier

Use this workflow when the user asks for resume review, refinement, modification, or wants a “drop zone” based process.

## Where files live

Use `career-os/Resume-Review/`:

- Inputs:
  - `inputs/resumes/` for master resumes
  - `inputs/job-postings/` for job descriptions
- Outputs:
  - `outputs/refined/` for general improvements
  - `outputs/tailored/<company> - <role>/` for job-specific tailoring
- Tracking:
  - `recommendations/JOB-RECOMMENDATIONS.md` for job recommendations based on the resume

## Process

1. **Clarify the goal**:
   - Improve the master resume (general refinement), OR
   - Tailor to a specific job description, OR
   - Both (refine first, then tailor).

2. **Get usable resume text**:
   - If the user dropped a PDF/DOCX, ask them to paste the text (or provide a text export) so you can edit precisely.

3. **Review and refine** (if requested):
   - Enforce single page.
   - Metrics-first bullets.
   - Remove internal jargon; translate to market language.
   - Tighten structure and consistency (titles, dates, tense, punctuation).
   - Output a refined version into `outputs/refined/`.

4. **Tailor to a job posting** (if provided):
   - Parse the JD (reuse the same parsing approach as `resume-tailor.md`).
   - Map requirements to Impact Library achievements (don’t invent).
   - Rewrite bullets using the JD vocabulary.
   - Save a tailored version under `outputs/tailored/<company> - <role>/`.
   - If the user intends to apply, create/update `Applications/<company>/` and move/copy final artifacts there.

5. **Job recommendations** (if requested):
   - Based on the resume, propose role types and job shapes that fit (titles, industries, constraints).
   - Track recommended jobs in `recommendations/JOB-RECOMMENDATIONS.md`.

