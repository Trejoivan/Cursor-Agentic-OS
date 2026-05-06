# personal-os: Manage Your Whole Life with AI

> Goals, relationships, health, projects, finances. One system, one conversation.

A Cursor-driven life management workspace that ties every task to a goal, tracks what matters across all areas of your life, and keeps you focused on meaningful progress.

## How It Works

1. **Define your goals** across all life areas (career, relationships, health, projects, finances)
2. **Capture tasks** naturally through conversation or brain dumps
3. **Cursor organizes everything** into structured tasks linked to your goals
4. **Ask "What should I work on today?"** and get focused, goal-aligned suggestions
5. **Weekly reviews** surface stale tasks, goal drift, and blind spots

## Core Question

**"How do I manage my whole life?"**

If you need professional task management specifically, see [work-os](../work-os/). If you need career search tools, see [career-os](../career-os/).

## Quick Start

Open the workspace in [Cursor](https://cursor.com), point a chat at `agentic-os/personal-os/`, and say:

```text
Help me set up personal-os
```

Cursor will walk you through:
1. Defining your life goals and priorities
2. Creating your first tasks across life areas
3. Setting up your Knowledge base for people, projects, and reference material

## What's Inside

```
personal-os/
├── AGENTS.md                    # Life management agent instructions
├── GOALS-template.md            # Starter goals file
├── workflows/                   # Specialized workflow references for Cursor
├── templates/
│   ├── task-template.md         # Task with YAML frontmatter
│   ├── knowledge-template.md    # Knowledge brief template
│   ├── project-template.md      # Multi-task project template
│   └── inbox-template.md        # Brain dump inbox
└── examples/
    └── workflows/
        ├── morning-standup.md   # Daily planning workflow
        ├── weekly-review.md     # Weekly reflection workflow
        └── inbox-processing.md  # Brain dump processing workflow
```

## Key Workflows

### Morning Planning
```
You: What should I work on today?

Cursor: Here's your focus for today:

        1. Follow up with contractor about kitchen estimate (urgent, due today)
        2. Prepare for tomorrow's meeting with financial advisor (important)
        3. 30-min workout (recurring, health goal)

        You have 2 tasks that are stale (no update in 14+ days). Want to review them?
```

### Brain Dump Processing
```
You: Process my inbox

Cursor: Reading INBOX.md...

        Created 5 tasks:
        • "Schedule dentist appointment" → admin (important)
        • "Research flights for July trip" → admin (on your radar)
        • "Call Mom about Eid plans" → relationships (urgent, time-sensitive)
        • "Review investment portfolio" → admin (important)
        • "Draft goals for Q2" → personal-development (important)

        Questions:
        • "Research flights" — do you have dates in mind? That affects priority.

        INBOX.md cleared!
```

## Life Categories

personal-os organizes tasks across 12+ areas of life:

| Category | What It Covers |
|---|---|
| `job-search` | Career exploration, applications, interviews |
| `wedding` | Wedding planning and logistics |
| `relationships` | Family, friends, community connections |
| `health` | Fitness, mental health, wellness |
| `admin` | Operations, finance, logistics, documentation |
| `learning` | Personal development, skill building |
| `outreach` | Follow-ups, networking, introductions |
| `personal-development` | Self-improvement, counseling, growth |
| `community-building` | Events, forums, member recruitment |
| `research` | Market analysis, studying models, gathering data |
| `partnerships` | Building organizational relationships |
| `project-development` | Strategic planning, program design |

## Priority Framework

| Priority | Meaning | Timeframe |
|---|---|---|
| **P0** | Must do | This week |
| **P1** | Important | This month |
| **P2** | Scheduled | Has a date |
| **P3** | Someday/maybe | No rush |

## Common Cursor Prompts

personal-os responds to natural language — there are no slash commands required:

| Prompt | What happens |
|--------|--------------|
| "Help me set up personal-os" | Personalize your workspace (~5 min) |
| "What should I work on today?" | Plan your day across all life areas |
| "Process my inbox" | Turn brain dumps into goal-linked tasks |
| "Run my weekly review" | Reflect across all life areas |
| "Add a task: …" | Capture a task from natural language |

## Requirements

- [Cursor](https://cursor.com)

## License

MIT
