# Daily Planner

Deep daily planning that goes beyond a flat task list. Use whenever the user says things like "plan my day", "what should I work on?", or "what's on for today?".

## Before You Start

If `GOALS.md` does not exist, ask the user to set up the workspace first ("It looks like work-os hasn't been set up yet — want me to walk you through it?") and stop. If a `Knowledge/profile.md` exists, read it for role context.

## Process

1. **Gather context**
   - Read `GOALS.md` to understand current objectives
   - Find every task file in `Active/` and read priority, status, due date, and any blockers
   - Check `Projects/` for milestones approaching this week
   - If a `.work-os-activity.log` exists, skim it for recent work patterns

2. **Multi-dimensional priority assessment**
   - **Urgency** — Hard deadlines today or tomorrow
   - **Impact** — What moves the needle most on stated goals
   - **Dependencies** — What unblocks other work or other people
   - **Momentum** — What has recent progress worth continuing
   - **Energy fit** — Heavier work for peak focus, lighter work for low-energy windows

3. **Pattern awareness** — surface gently
   - Goal areas with no active tasks
   - Too many items currently marked urgent (suggest re-prioritizing)
   - Tasks stuck "in progress" too long
   - Categories that consistently get ignored

## Output Format

Always conversational. Never show YAML, priority codes, or status codes.

- **Today's Focus** — 2-4 items maximum
- **If You Have Time** — 1-2 stretch items
- **Heads Up** — upcoming deadlines, stalled work, gaps in goal coverage
- A brief encouraging note about overall trajectory

## Rules

- Never suggest more than 4 focus items
- Always tie suggestions back to a goal
- Use "urgent" and "important", never "P0" or "P1"
- Use "in progress" and "blocked", never "s" or "b"
- Be direct and concise — these are busy professionals
