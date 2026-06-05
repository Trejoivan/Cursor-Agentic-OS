---
type: bmad-distillate
distillate_kind: daily-brief
created: "{{YYYY-MM-DD}}"
downstream_consumer: "bmad-correct-course | bmad-edit-prd | bmad-sprint-status | bmad-help"
sources:
  - "{{path/to/source-notes-1.md}}"
  - "{{path/to/source-notes-2.md}}"
linked_project: "{{bmad-project-slug | none}}"
token_estimate: 800
parts: 1
---

# BMAD Daily Brief — {{title}}

## Change summary (since last brief)
- {{what materially changed today — scope, constraints, decisions, new evidence}}

## Current objective (what we’re trying to do right now)
- {{1–2 bullets; keep tight}}

## Confirmed facts / non-negotiables
- {{constraints that should not be re-debated unless explicitly reopened}}

## Decisions & confirmations (include rationale)
- {{Decision}} — because {{short rationale}}
- Rejected: {{alternative}} — because {{short rationale}}

## Scope delta
- Added:
  - {{feature / requirement / workstream}}
- Removed:
  - {{feature / requirement / workstream}}
- Deferred:
  - {{feature / requirement / workstream}} (why / until when)

## New constraints (or changes to existing ones)
- {{time/budget/tech/compliance/legal/partner/API/infra}}

## Key takeaways (compressed, decision-relevant)
- {{dense bullets that would affect PRD/epics/architecture/UX}}

## Impact notes (for course-correct)
- **PRD**: {{what sections likely need update}}
- **Epics/Stories**: {{what epics/stories are impacted}}
- **Architecture**: {{what decisions/components are impacted}}
- **UX**: {{what flows/screens change}}

## Open questions (ordered by what blocks progress)
1. {{question}} (why it matters / what decision it gates)
2. {{question}}

## Risks & unknowns
- {{risk}} — mitigation: {{idea}} — owner: {{name|tbd}}

## Evidence / links
- {{short description}}: {{link or file reference}}

## Next actions
- {{action}} — owner: {{name|tbd}} — due: {{YYYY-MM-DD|tbd}}

