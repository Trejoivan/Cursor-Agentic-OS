---
type: bmad-distillate
distillate_kind: weekly-brief
created: "{{YYYY-MM-DD}}"
range:
  start: "{{YYYY-MM-DD}}"
  end: "{{YYYY-MM-DD}}"
downstream_consumer: "bmad-correct-course | bmad-edit-prd | bmad-sprint-status | bmad-help"
sources:
  - "{{path/to/daily-brief-1.md}}"
  - "{{path/to/daily-brief-2.md}}"
linked_project: "{{bmad-project-slug | none}}"
token_estimate: 1200
parts: 1
---

# BMAD Weekly Brief — {{week label}}

## Week-in-one-paragraph (tight, decision-relevant)
- {{what changed, what was decided, what’s now true}}

## Net changes (the "diff" for BMAD)
- **New confirmations**:
  - {{facts / decisions that are now locked}}
- **Scope changes**:
  - Added: {{...}}
  - Removed: {{...}}
  - Deferred: {{...}}
- **Constraint changes**:
  - {{new/updated constraints}}

## Key takeaways (compressed)
- {{dense bullets that would affect PRD/epics/architecture/UX}}

## Decisions & rationale (only the ones that matter going forward)
- {{Decision}} — because {{rationale}}
- Rejected: {{alternative}} — because {{rationale}}

## Impact notes (for course-correct)
- **PRD**: {{what sections must be updated}}
- **Epics/Stories**: {{what epics/stories changed}}
- **Architecture**: {{what architecture decisions changed}}
- **UX**: {{what flows/screens changed}}

## Open questions (top blockers)
1. {{question}} (gates {{decision}})
2. {{question}}

## Risks & unknowns (with mitigation owners)
- {{risk}} — mitigation: {{idea}} — owner: {{name|tbd}}

## Next-week focus (what BMAD should optimize for)
- {{1–3 bullets}}

## Evidence / links
- {{short description}}: {{link or file reference}}

