# Project Intake + Ongoing Context Updates

Turn a project idea into a tracked project through a short chat process, and keep it updated over time via conversation.

## When to Use

Use this workflow when the user says things like:
- "I have a project idea"
- "Create a new project for …"
- "Help me scope this project"
- "Update the project context for …"
- "Add context to my project …"

## Core Principle

The user answers questions in chat. The assistant updates the project files behind the scenes (project `README.md`, intake notes, and initial tasks). Never ask one question at a time—use short rounds and batch questions.

## Start: Identify / Create the Project

1. Determine the project name from the user. If unclear, infer a short working name and confirm in one line.
2. Ensure a project folder exists: `Projects/<project-slug>/`
3. Ensure these subfolders exist (create if missing):
   - `tasks/`
   - `specs/`
   - `meetings/`
   - `deliverables/`
4. Ensure there is:
   - `Projects/<project-slug>/README.md`
   - `Projects/<project-slug>/tasks/00-project-intake.md`

If the user already has a project folder, read the project `README.md` first and continue from the current state instead of restarting.

## The Intake Conversation (3 rounds)

### Round 1 — One-liner + Target + Constraints

Ask for:
- What is it (one sentence)?
- Who is it for?
- What outcome do they want?
- Any hard constraints (deadline, budget, dependencies)?

### Round 2 — Scope + Success + Risks

Ask for:
- MVP: what must be true for "v1" to be considered shipped?
- Out of scope: what is explicitly not included (for now)?
- Success metrics: primary metric + 1–2 leading indicators + guardrails (cost, quality, risk)
- Top risks + mitigations

### Round 3 — Plan + First tasks

Ask for:
- 2–5 milestones (or phases) and rough dates if they have them
- Key stakeholders (names/roles if known)
- Next 3 actions they want to take this week

## Write Outputs (Behind the Scenes)

Update the project files after each round:

1. **Project README**
   - Fill in: Overview, Goal, Success Metrics, Timeline, Stakeholders, Risks
   - Add/append a dated entry under “Recent Updates”
   - Keep status simple and honest (default to “On Track | 0% | Target: TBD” if unknown)

2. **Intake notes (`tasks/00-project-intake.md`)**
   - Capture the user’s answers verbatim where possible
   - Keep it as the “source notes” for why/how decisions were made

3. **Initial tasks**
   - Convert the “next 3 actions” into 1–3 task files in `Projects/<project-slug>/tasks/`
   - Make tasks atomic and action-oriented
   - If the workspace has `Active/` categories, you may place execution tasks there instead, but keep at least the intake notes in the project folder

## Ongoing Updates (Chat-Driven)

When the user says "update project context" or shares new information:

1. Read the current project `README.md`
2. Ask a single batched question set:
   - What changed?
   - Any new risks or blockers?
   - Any decision made?
   - What’s next?
3. Update:
   - “Recent Updates” with a dated entry
   - Status line (on track / at risk / blocked) if warranted
   - Tasks list (add/close tasks as needed)

## User-Facing Response Rules

- Never show file paths, YAML, or internal metadata.
- Confirm outcomes in plain language:
  - the project name
  - the 2–4 most important facts captured
  - the next 2–3 actions created or updated
- Keep the conversation moving: end with the next prompt the user can say (e.g., “Add context to this project: …”).

