# Resume Tailor

Take a job description and produce a tailored resume by mapping the user's achievements to the role's requirements.

## Process

1. **Parse the JD** into structured requirements: must-have skills, preferred skills, key responsibilities, success metrics, domain language

2. **Assess fit** on 5 dimensions (1-10 each):
   - Technical skill match
   - Domain experience
   - Leadership / scope alignment
   - Culture / values fit (from company research)
   - Growth trajectory alignment

   Be honest about gaps.

3. **Map experience** from the Impact Library to each JD requirement. Note gaps with no match.

4. **Translate domain language** using `docs/domain-translation.md`. Rewrite bullets using the target company's vocabulary while preserving metrics.

5. **Produce tailored resume JSON** following the schema in `templates/resume-data.json`. Save to `Applications/[company]/resume.json`.

6. **Verify**
   - Single page constraint
   - Metrics-first bullets
   - No promotion metrics used as selling points
   - No unrecognizable jargon for the target

## Writing Rules

- Lead every bullet with a measurable outcome
- Never use promotion history as a selling point — let stacked role titles show trajectory
- Use the target company's vocabulary, not your past company's internal jargon
- Each bullet must pass the "so what?" test
- Be honest about fit. Sugarcoating wastes everyone's time.
