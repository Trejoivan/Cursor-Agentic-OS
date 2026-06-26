# meeting-os: Never Lose Track of Meetings Again

> Decisions tracked. Action items captured. Follow-ups managed. All through conversation.

A Cursor-driven meeting lifecycle workspace that handles preparation, note-taking, decision tracking, and follow-up. Integrates with [Granola](https://granola.ai) for AI-powered transcription.

## How It Works

1. **Before a meeting**, Cursor reviews past meetings with the same people and surfaces open commitments
2. **After a meeting**, capture notes or pull a transcript, and Cursor extracts decisions, action items, and follow-ups
3. **Between meetings**, Cursor tracks what was promised, what's overdue, and what needs attention
4. **Over time**, build a searchable history indexed by person, project, and decision

## Core Question

**"What happened in that meeting?"**

If you need professional task management, see [work-os](../work-os/). If you need life management, see [personal-os](../personal-os/).

## Quick Start

Open the workspace in [Cursor](https://cursor.com), point a chat at `agentic-os/meeting-os/`, and say:

```text
Help me set up meeting-os
```

Cursor will walk you through:
1. Setting up your meeting notes structure (final records stored in `meeting-os/`)
2. Connecting with Granola (optional, for automatic transcription)
3. Creating your first meeting note

Use `AD_HOC/Meetings/` as a scratch space for prep docs, draft agendas, and temporary meeting artifacts.

## What's Inside

```
meeting-os/
├── AGENTS.md                     # Meeting agent instructions
├── docs/
│   ├── granola-integration.md    # How to connect with Granola
│   └── decision-tracking.md      # How decisions are tracked across meetings
├── workflows/                    # Specialized workflow references for Cursor
├── templates/
│   ├── meeting-note.md           # Meeting note with YAML frontmatter
│   ├── action-item.md            # Action item to task conversion
│   └── meeting-prep.md           # Pre-meeting preparation template
└── examples/
    └── workflows/
        ├── post-meeting.md       # After meeting workflow
        └── meeting-prep.md       # Before meeting workflow
```

## Key Workflows

### Meeting Prep
```
You: I have a meeting with Sarah tomorrow. Help me prepare.

Cursor: Reviewing your history with Sarah...

        Last meeting: Jan 15 (product roadmap review)
        Key decisions from last time:
        • Agreed to prioritize mobile app redesign
        • Sarah committed to sharing user research by Feb 1

        Open commitments:
        • You owe Sarah the updated timeline (due last week)
        • Sarah's user research is 2 weeks overdue

        Suggested agenda:
        1. Follow up on user research status
        2. Share updated timeline
        3. Review mobile app redesign progress
```

### Post-Meeting Processing
```
You: Just finished my meeting with the product team. Here are my notes: [paste notes]

Cursor: Processing your meeting notes...

        Decisions:
        • Launch date moved to March 15
        • Budget approved for contractor support

        Action Items:
        • You: Draft contractor SOW by Friday
        • Sarah: Update project timeline by Monday
        • Team: Review designs in next standup

        Follow-ups created:
        • Reminder: Check on Sarah's timeline update (Monday)
        • Reminder: Your SOW draft (Friday)

        Meeting saved to: Meetings/2026-02-15-product-team.md
```

### Decision Search
```
You: When did we decide to move the launch date?

Cursor: Found in "Product Team Sync" (Feb 15, 2026):
        Decision: Launch date moved from March 1 to March 15
        Reason: Need additional QA time for mobile
        Owner: Sarah (project lead)
        Attendees: You, Sarah, James, Lisa
```

## Granola Integration

meeting-os works great on its own with manual notes, but it's even better with [Granola](https://granola.ai):

- **Automatic transcription** of your meetings
- **Pull transcripts** directly into meeting-os
- **Query past meetings** by topic, person, or date
- **Extract exact quotes** when you need precise wording

See [docs/granola-integration.md](docs/granola-integration.md) for setup instructions.

## Common Cursor Prompts

meeting-os responds to natural language — there are no slash commands required:

| Prompt | What happens |
|--------|--------------|
| "Help me set up meeting-os" | Personalize your workspace (~3 min) |
| "Process these meeting notes" | Extract decisions, action items, and follow-ups |
| "Prep me for my meeting with [name]" | History, open items, suggested agenda |

## Requirements

- [Cursor](https://cursor.com)
- [Granola](https://granola.ai) (optional, for automatic transcription)

## License

MIT
