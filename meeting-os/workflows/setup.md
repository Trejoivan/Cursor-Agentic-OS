# Set Up meeting-os

Guide the user through setting up their meeting management system. About 3 minutes total.

## Before You Start

Check if `Meetings/`, `Decisions/`, `Actions/`, and `People/` exist. If they do, offer to reconfigure rather than starting over.

## The Conversation (2 rounds)

1. **Explain the system**

   "meeting-os tracks your meetings, decisions, action items, and commitments. After each meeting I extract what matters; before each meeting I surface what you need to know."

2. **Ask about workflow**

   "Do you use Granola for meeting transcription? And who are the people you meet with most often?"

## Build the Workspace

Create:

- `Meetings/`, `Decisions/`, `Actions/`, `People/` directories
- If they named frequent contacts, create starter `People/` files for those names

## Welcome Message

Suggest natural-language next steps:

- "Process these meeting notes"
- "Prep me for my meeting with [name]"

## Rules

- Never show file paths or YAML
- Cap the conversation at 2 rounds
- About 3 minutes total
