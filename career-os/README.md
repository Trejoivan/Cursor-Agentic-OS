# career-os: Land Your Next Role with AI

> Drop a job description. Get a tailored resume, interview prep, and tracked application, all through conversation.

A Cursor-driven career management workspace that handles the full job search lifecycle: resume tailoring, STAR story preparation, interview coaching, application tracking, and learnings capture.

## How It Works

1. **Build your impact library** by documenting achievements with metrics, context, and alternate framings
2. **Drop a job description** and say "tailor my resume"
3. **Cursor parses the JD**, assesses fit, maps your experience, translates domain language, and rewrites your resume
4. **Prepare for interviews** with algorithm-labeled STAR stories, probe answer practice, and company research
5. **Track everything** from application to outcome, capturing learnings that improve your next attempt

## Core Question

**"How do I land my next role?"**

If you need professional task management, see [work-os](../work-os/). If you need life management, see [personal-os](../personal-os/).

## Quick Start

Open the workspace in [Cursor](https://cursor.com), point a chat at `agentic-os/career-os/`, and say:

```text
Help me set up career-os
```

Cursor will walk you through:
1. Building your initial impact library from your resume
2. Creating your first set of STAR stories
3. Setting up your application tracker

## What's Inside

```
career-os/
├── AGENTS.md                     # Full career agent instructions
├── docs/
│   ├── how-it-works.md           # End-to-end flywheel explanation
│   ├── domain-translation.md     # How to translate experience across industries
│   └── stories-framework.md      # Building reusable STAR stories
├── workflows/                    # Specialized workflow references for Cursor
├── templates/
│   ├── resume-data.json          # Empty resume JSON schema
│   ├── impact-library.md         # Achievement documentation template
│   ├── jd-analysis.md            # Job description parsing template
│   ├── application-tracker.md    # Track applications and outcomes
│   ├── star-story.md             # Reusable STAR story template
│   ├── interview-prep.md         # Pre-interview checklist
│   └── outcome-log.md            # Post-interview capture template
└── examples/
    └── workflows/
        ├── resume-tailoring.md   # Step-by-step resume tailoring workflow
        └── interview-prep.md     # Interview preparation workflow
```

## Key Workflows

### Resume Tailoring
```
You: [paste job description] Tailor my resume for this role.

Cursor: Parsing JD... Here's my analysis:

        Fit Score: 78/100
        Strong matches: Technical operations, cross-functional leadership, process optimization
        Gaps to address: No direct experience with their specific tooling
        Domain translation needed: "Support engineering" → "Technical Operations"

        Ready to generate tailored resume?
```

### Interview Prep
```
You: I have an interview with [Company] tomorrow. Help me prepare.

Cursor: Reading your application and stories...

        Company Research: [key findings]
        Role Focus: [what they care about most]

        Top 3 stories to prepare:
        1. [Story] — covers their #1 requirement
        2. [Story] — addresses the gap in your resume
        3. [Story] — shows leadership at scale

        Let's practice. Tell me the first story in 90 seconds.
```

## The Career Flywheel

Every application makes the next one better:

```
Impact Library → Tailored Resume → Interview → Outcome
      ↑                                          |
      └──── Learnings ← Outcome Log ←────────────┘
```

- **Wins** become new stories with verified metrics
- **Rejections** produce learnings about positioning and domain language
- **Interview feedback** refines how you tell stories
- **New achievements** expand your impact library

## Common Cursor Prompts

career-os responds to natural language — there are no slash commands required:

| Prompt | What happens |
|--------|--------------|
| "Help me set up career-os" | Build the impact library and stories (~10 min) |
| "Tailor my resume for this job description: …" | Parse JD, score fit, produce tailored resume |
| "Help me prep for this interview" | Stories, research, practice |
| "Log the outcome from [company]" | Capture result and learnings |

## Requirements

- [Cursor](https://cursor.com)

## License

MIT
