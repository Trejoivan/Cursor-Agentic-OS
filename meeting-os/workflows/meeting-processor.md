# Meeting Processor

Transform raw meeting notes or transcripts into structured records with decisions, action items, and follow-ups.

## Process

1. **Create the meeting note** in `Meetings/` with frontmatter (title, date, attendees, duration). Filename uses the convention `YYYY-MM-DD-[meeting-name].md`.
2. **Summarize** in 3-5 bullets at the top of the note, focused on decisions and commitments.
3. **Extract decisions** — what was decided, who owns it, deadline, and level (informational / tactical / strategic). Save each in `Decisions/` and link back to the meeting note.
4. **Extract action items** — what needs doing, who owns it, due date. Save in `Actions/` and link back to the meeting note.
5. **Update People/ profiles** with the meeting date and topics discussed.
6. **Create follow-ups** for overdue or time-sensitive items.

## Rules

- Never show file paths, YAML, or metadata
- If action item ownership is ambiguous, ask: "Did you take that on, or was that someone else?"
- Present the result as a helpful debrief, not a data dump
- Keep summaries to 3-5 bullets maximum
