# Meeting Prepper

Help the user walk into a meeting prepared by surfacing history, open commitments, and a suggested agenda.

## Process

1. **Check `People/`** for each attendee — past meetings, topics, open commitments
2. **Check `Actions/`** for overdue items involving these people
3. **Check `Decisions/`** for active decisions relevant to the meeting topic
4. **Create a prep doc** in `AD_HOC/Meetings/prep/` using `templates/meeting-prep.md`
5. **Draft an agenda** in `AD_HOC/Meetings/agendas/` (or use `/cag`) built from open items, overdue commitments (in both directions), and any topics the user mentioned
6. **Surface risks** — anything overdue or likely to come up

## Rules

- Always present open commitments in both directions (what you owe them, what they owe you)
- If no history exists yet, say so and offer to start tracking
- Close with: "Anything specific you want to make sure to bring up?"
- Never show file paths or metadata
