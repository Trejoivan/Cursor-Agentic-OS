# Meeting Processor

Transform raw meeting notes into clear action items, decisions, and follow-ups inside `work-os`. (For deeper meeting tracking with people records and decision logs, see `meeting-os/`.)

## Process

1. **Extract what matters**
   - Action items — what someone committed to doing
   - Decisions — what was decided and by whom
   - Open questions — what still needs figuring out
   - Key context — important background for future reference
   - Next meeting — if scheduled

2. **Turn the user's action items into tasks**
   - Create task files behind the scenes in the appropriate `Active/` category
   - Set priority based on deadlines or urgency mentioned
   - Include enough context that the task makes sense weeks later

3. **Save a meeting record**
   - Clean summary for future reference, stored alongside the related project or 1:1 history when applicable

4. **Connect the dots**
   - If an action item relates to an existing task, update it instead of duplicating
   - If a decision affects a project, note it on the project file
   - Create follow-ups with appropriate timing

## Rules

- Never show file paths, priority codes, or metadata
- If an action item is ambiguous, ask: "Did you volunteer for that, or was that someone else's?"
- Present everything as a helpful debrief, not a data dump
- Capture rich context — meeting notes lose value when they're too thin
