---
type: mini-bmad-template
name: BMAD summary assist prompts
---

# BMAD summary assist prompts (mini-bmad)

Use these to ask BMAD role agents to help you complete:

- `summary/BMAD-DAILY-BRIEF.md`
- `summary/BMAD-WEEKLY-BRIEF.md`

## Paige (Tech Writer) — `bmad-agent-tech-writer`

Prompt:

“Paige: take `NOTES.md` + `summary/BMAD-DAILY-BRIEF.md`. Propose edits to the brief only (do not rewrite my raw notes). Keep the existing headings, use dense bullets, and add missing items as explicit TODO questions.”

## John (Product Manager / Technical PM) — `bmad-agent-pm`

Prompt:

“John: review `summary/BMAD-DAILY-BRIEF.md` and turn fuzzy bullets into explicit confirmations, scope delta (added/removed/deferred), and a prioritized list of open questions that block decisions. Output as edits under the existing headings.”

## Winston (System Architect / “Solution manager”) — `bmad-agent-architect`

Prompt:

“Winston: read `summary/BMAD-DAILY-BRIEF.md` and produce a brief impact assessment under: PRD / Epics-Stories / Architecture / UX. Call out trade-offs and any inconsistencies that will cause rework.”

## Mary (Business Analyst) — `bmad-agent-analyst`

Prompt:

“Mary: distill today into 10–15 decision-relevant bullets. List contradictions, assumptions, and unknowns that need confirmation. Keep it tight.”

## Sally (UX Designer) — `bmad-agent-ux-designer`

Prompt:

“Sally: improve only the UX-relevant parts of `summary/BMAD-DAILY-BRIEF.md`: impacts, edge cases, and missing flows/confirmations. Keep the headings and keep it dense.”

## Amelia (Developer) — `bmad-agent-dev`

Prompt:

“Amelia: sanity-check `summary/BMAD-DAILY-BRIEF.md` for implementation readiness. Convert next actions into concrete steps, add missing technical dependencies, and flag acceptance-criteria gaps.”

## Caravaggio (Presentation Expert) — `bmad-cis-agent-presentation-master`

Prompt:

“Caravaggio: turn `summary/BMAD-WEEKLY-BRIEF.md` into a 5–8 slide outline (key message per slide, narrative arc, and the ask from stakeholders).”

## Sophia (Storyteller) — `bmad-cis-agent-storyteller`

Prompt:

“Sophia: rewrite the weekly brief’s ‘week-in-one-paragraph’ so it’s crisp and compelling while preserving factual decisions and scope/constraint changes.”

