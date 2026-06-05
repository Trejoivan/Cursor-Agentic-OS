## BMAD agents you can use for mini-bmad briefs

This repo already includes BMAD “role agents” under `_Bmad/.agents/skills/`. In mini-bmad, use them as **specialists to help you fill**:

- `summary/BMAD-DAILY-BRIEF.md`
- `summary/BMAD-WEEKLY-BRIEF.md`

### Role mapping (what you asked for)

- **Tech writer** → **Paige** (`bmad-agent-tech-writer`)
  - Best for: converting messy notes into dense, consistent briefs; tightening wording; keeping “what changed” crisp.
- **Technical product manager** → **John** (`bmad-agent-pm`)
  - Best for: clarifying requirements, confirmations, open questions, next actions; making sure scope deltas are explicit.
- **Solution manager** (closest in this repo) → **Winston** (`bmad-agent-architect`)
  - Best for: impact analysis across Architecture/UX/Stories; trade-offs; what needs to change in the plan.

Optional extra:

- **Business analyst** → **Mary** (`bmad-agent-analyst`)
  - Best for: compressing takeaways into “decision-relevant” bullets; identifying missing info and contradictions.

### Additional agents I recommend including

- **UX / product UX impacts** → **Sally** (`bmad-agent-ux-designer`)
  - Best for: writing the UX impact section crisply; catching missing flows, edge cases, and UX acceptance criteria implications.
- **Implementation reality check** → **Amelia** (`bmad-agent-dev`)
  - Best for: turning "next actions" into concrete, implementable steps; spotting missing acceptance criteria or technical dependencies.
- **Presentation-ready weekly wrap** → **Caravaggio** (`bmad-cis-agent-presentation-master`)
  - Best for: converting weekly brief into an outline/message map for stakeholders; making the "so what" land.
- **Narrative clarity** → **Sophia** (`bmad-cis-agent-storyteller`)
  - Best for: tightening the weekly "one paragraph" narrative and making decisions read as a coherent story.

### How to use (repeatable micro-loop)

1. Work normally in the run (`NOTES.md`, artifacts, links).
2. Keep `summary/BMAD-DAILY-BRIEF.md` up to date (or `BMAD-WEEKLY-BRIEF.md` for weekly).
3. Ask a role agent to help you **edit the brief** (not rewrite your raw notes).
4. When ready to produce a single file and/or sync into a major BMAD project:
   - `.\scripts\mini-bmad.ps1 brief "<run-slug>" -Sync`
   - `.\scripts\mini-bmad.ps1 weekly "<run-slug>" -Sync`

### Copy/paste prompt starters

#### Paige (tech writer)

- “Paige: read `NOTES.md` + `summary/BMAD-DAILY-BRIEF.md` and propose a tight update to the brief. Keep the existing headings, use dense bullets, and only add what is supported by the notes. Flag missing fields as questions.”

#### John (technical PM)

- “John: review `summary/BMAD-DAILY-BRIEF.md` for ambiguity. Convert vague bullets into testable confirmations, explicit scope delta (added/removed/deferred), and a prioritized list of open questions that block progress.”

#### Winston (solution/architect)

- “Winston: based on `summary/BMAD-DAILY-BRIEF.md`, produce an impact checklist for PRD/Epics/Architecture/UX. Call out likely downstream changes and any risky inconsistencies.”

#### Mary (analyst)

- “Mary: distill today’s notes into 10–15 decision-relevant bullets and identify contradictions, assumptions, and unknowns that should be confirmed.”

#### Sally (UX)

- “Sally: review `summary/BMAD-DAILY-BRIEF.md` and improve only the UX-related parts: impacts, edge cases, and any missing flows or UX confirmations needed. Keep it dense and practical.”

#### Amelia (dev)

- “Amelia: sanity-check `summary/BMAD-DAILY-BRIEF.md` for implementation readiness. Convert next actions into concrete steps, add missing technical dependencies, and flag any acceptance-criteria gaps.”

#### Caravaggio (presentation)

- “Caravaggio: turn `summary/BMAD-WEEKLY-BRIEF.md` into a 5–8 slide outline with key messages, narrative arc, and what we need from stakeholders.”

#### Sophia (storyteller)

- “Sophia: rewrite the weekly brief’s ‘week-in-one-paragraph’ so it’s crisp and compelling, while preserving the factual decisions and scope changes.”

