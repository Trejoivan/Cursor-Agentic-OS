# Setting Up work-os with Cursor

> A step-by-step guide to getting Cursor and work-os running on your machine.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Steps](#installation-steps)
3. [Understanding Key Files](#understanding-key-files)
4. [Your First Session](#your-first-session)
5. [Core Workflows](#core-workflows)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

You only need two things:

1. **[Cursor](https://cursor.com)** — Cursor reads `AGENTS.md` and the `.cursor/rules/` folder automatically, so it picks up the work-os harness as soon as you open the workspace.
2. **Git** — To clone the repo. Any recent version is fine.

That's it — no Node.js, no API key configuration, no extra CLI to install. Cursor handles authentication and model access for you.

---

## Installation Steps

### Visual Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 1: Install Cursor                                                 │
│  Download from https://cursor.com                                       │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 2: Clone the agentic-os repository                                │
│  git clone https://github.com/ahmadelswify/agentic-os.git               │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 3: Open the workspace in Cursor                                   │
│  File → Open Folder → choose `agentic-os/`                              │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 4: Open a Cursor chat inside `work-os/`                           │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 5: Start your first workflow                                      │
│  "Help me set up work-os"                                               │
└─────────────────────────────────────────────────────────────────────────┘
```

---

### Step 1: Install Cursor

Download Cursor from [cursor.com](https://cursor.com) and finish first-time setup. Cursor handles model authentication on its own.

### Step 2: Clone the Repository

```bash
git clone https://github.com/ahmadelswify/agentic-os.git
```

Pick a location you can find again (for example `~/Documents/agentic-os` on macOS/Linux or `C:\Users\<you>\Documents\agentic-os` on Windows).

### Step 3: Open the Workspace

In Cursor, choose **File → Open Folder** and select the cloned `agentic-os/` folder. Cursor automatically picks up:

- The Cursor rules in `agentic-os/.cursor/rules/` and the parent workspace `.cursor/rules/`
- The OS-specific `AGENTS.md` files (work-os, personal-os, meeting-os, career-os)

### Step 4: Open a Cursor Chat in `work-os/`

Open any file inside `agentic-os/work-os/` (for example `AGENTS.md`) and open a new chat. The matching Cursor rule will attach automatically when you ask about anything in this folder.

### Step 5: Start Your First Workflow

In the chat, type:

```
Help me set up work-os
```

Cursor will:

1. Ask about your role and work types
2. Create your personalized directory structure
3. Set up your `GOALS.md` and `BACKLOG.md` files from the templates
4. Help you do your first brain dump
5. Organize everything into tasks

This takes about 5 minutes and you'll have a fully personalized productivity system.

---

## Understanding Key Files

### AGENTS.md

**Location**: `agentic-os/work-os/AGENTS.md`

**Purpose**: A short table of contents that tells Cursor where to find instructions.

**Think of it as**: The map, not the manual. It points to deeper instruction files in `docs/` and `workflows/` that Cursor reads on demand.

**The `docs/` directory** contains the full harness:
- `docs/agent-instructions/` — How to process inbox, manage tasks, align goals, etc.
- `docs/workflows/` — Auto-detected workflows (content writing, weekly review, resume tailoring)
- `docs/validation/` — Rules Cursor checks after creating tasks
- `docs/garbage-collection/` — Cleanup rules for stale tasks and orphaned files

**The `workflows/` directory** contains specialized workflow references — what to do for "plan my day", "process my backlog", "log this accomplishment", etc.

**You can customize** by editing files in `docs/` or `workflows/` — each one is focused on one topic.

---

### GOALS.md

**Location**: `agentic-os/work-os/GOALS.md`

**Note:** This file is created during your initial setup from `GOALS-template.md`. Cursor will help you populate it when you say "Help me set up work-os".

**Purpose**: Your strategic objectives and priorities.

**Cursor uses this to**:
- Evaluate which tasks are most important
- Suggest daily priorities aligned with your goals
- Filter out distractions that don't serve your objectives

**Example structure**:
```markdown
# Goals

## This Quarter
1. Launch new product feature
2. Grow team from 3 to 5 people
3. Improve deployment speed by 50%

## Key Metrics
- User retention: 85%+
- Deploy frequency: 2x per week
- Team satisfaction: 8/10+
```

---

### BACKLOG.md

**Location**: `agentic-os/work-os/BACKLOG.md`

**Note:** This file is created during your initial setup from `BACKLOG-template.md`. Cursor will help you create it when you say "Help me set up work-os".

**Purpose**: Your brain dump inbox.

**How to use it**:
- Throughout your day, quickly capture thoughts here
- Don't organize, just write
- End of day, tell Cursor "process my backlog"
- Cursor organizes everything into structured tasks

**Example**:
```markdown
# Backlog

- Follow up with Sarah about the contract renewal
- Draft the script for next week's video
- Review pull request from James
- Research competitors' new features
- Book hotel for conference next month
```

---

### Directory Structure

After setup, your work-os will look like:

```
work-os/
├── AGENTS.md              # AI map (points to docs/ and workflows/)
├── GOALS.md               # Your objectives and priorities
├── BACKLOG.md             # Brain dump inbox
│
├── docs/                  # The harness (AI instructions, workflows, validation)
│   ├── golden-principles.md
│   ├── agent-instructions/
│   ├── workflows/
│   ├── validation/
│   └── garbage-collection/
│
├── workflows/             # Specialized workflow references for Cursor
│
├── Active/                # Current work (YOUR CATEGORIES)
│   ├── client-work/
│   ├── projects/
│   ├── meetings/
│   └── admin/
│
├── Projects/              # Multi-task initiatives
├── Career/                # Professional development
├── Knowledge/             # Reference materials
├── Archive/               # Completed work
└── .health/               # Generated health reports (gitignored)
```

The `Active/` structure is personalized during setup based on YOUR role.

---

## Your First Session

Let's walk through a complete first session inside Cursor.

### Setup Conversation

```
You: Help me set up my work-os

Cursor: I'll help you set up work-os for your needs. A few questions:

1. What's your role? (e.g., software engineer, marketer, content creator, etc.)
2. What types of work fill your day?

You: I'm a product manager. I manage feature development, talk to customers,
     and work with engineering and design teams.

Cursor: Great! To customize this for you:

1. What makes something urgent in your work?
2. What do you want to spend less time organizing?
3. What are your main goals right now?

You: Urgent is usually customer escalations or release blockers. I lose track
     of customer feedback and forget to follow up. Goals are to ship v2.0 this
     quarter and improve our customer satisfaction score.

Cursor: Perfect! Let me set up work-os for product management...

[Creates directory structure]
[Sets up GOALS.md]

Done! Your structure:

Active/
├── feature-work/      # Feature development and specs
├── customers/         # Customer conversations and feedback
├── engineering/       # Engineering coordination
├── design/            # Design collaboration
└── planning/          # Roadmap and strategy

Your goals (in GOALS.md):
- Ship v2.0 this quarter
- Improve customer satisfaction score
- Better tracking of customer feedback

Now, brain dump everything on your mind — tasks, projects, ideas, anything.
```

### Brain Dump

```
You:
- Need to review the search feature spec with engineering
- Follow up with AcmeCorp about their feature request
- Schedule design review for the dashboard redesign
- Customer escalation from BetaCo - login issues
- Draft Q2 roadmap for stakeholder review
- Research competitor pricing models
- Prep for 1:1 with my manager on Friday

Cursor: [Processing...]

All organized! Here's what I created:

Urgent (this week):
• Customer escalation - BetaCo login issues
• Review search feature spec with engineering (blocking development)
• Prep for 1:1 with manager (Friday)

Important (this month):
• Follow up with AcmeCorp feature request
• Schedule design review for dashboard redesign
• Draft Q2 roadmap for stakeholder review

On your radar:
• Research competitor pricing models

Your work-os is ready! Here's how to use it:

Morning: "What should I work on today?"
During work: Add notes to BACKLOG.md
End of day: "Process my backlog"
Weekly: "Run my weekly review"

Want me to show you what to focus on today?
```

### Daily Use

```
You: What should I work on today?

Cursor: Here's your focus for today:

Urgent:
1. BetaCo login escalation - customer is blocked (30 min estimated)
2. Review search feature spec - engineering is waiting (1 hour estimated)

If you finish those:
3. Prep for Friday's 1:1 - gather your wins and discussion topics

The escalation is your top priority since the customer can't use the product.
After that, unblock engineering on the search feature.

You're in good shape. Two critical items, then you can breathe.
```

---

## Core Workflows

### Morning Planning

In a Cursor chat scoped to `work-os/`:

```
You: What should I work on today?
```

Cursor reviews your tasks, goals, and priorities to suggest your daily focus.

---

### Brain Dumping

Throughout your day, capture thoughts in `BACKLOG.md`:

- **Option 1:** Edit `BACKLOG.md` directly in Cursor or any editor
- **Option 2:** Tell Cursor in chat:

  ```
  You: Add to backlog: Call vendor about invoice discrepancy
  ```

---

### Processing Your Backlog

```
You: Process my backlog
```

Cursor reads `BACKLOG.md`, creates organized task files, assigns priorities, and clears your inbox.

---

### Updating Task Status

```
You: Mark [task name] as done
You: Update [task name] status to in progress
You: Block [task name] - waiting on legal review
```

---

### Weekly Review

```
You: Run my weekly review
```

Cursor helps you:
- Review what you accomplished
- Identify what's still pending
- Clean up completed tasks
- Plan next week's priorities

---

## Troubleshooting

### Cursor isn't following the work-os rules

**Problem**: The chat doesn't seem to be reading `AGENTS.md` or applying the harness.

**Solution**:
1. Confirm you opened the parent `agentic-os/` folder (or any folder above `work-os/`) so Cursor sees `.cursor/rules/`.
2. Open a file inside `work-os/` and open a fresh chat. The work-os rule attaches based on file globs.
3. Ask Cursor to read `AGENTS.md` explicitly: "Read agentic-os/work-os/AGENTS.md and follow it."

---

### Cursor doesn't see my files

**Problem**: Cursor is in a different workspace or chat scope.

**Solution**:
1. Make sure the workspace root in Cursor is the cloned `agentic-os/` directory (or its parent).
2. Open a file inside `work-os/` so Cursor's working file context is correct, then start a new chat.

---

### Tasks aren't being created

**Problem**: Required directories may not exist yet.

**Solution**: Run setup again — "Help me set up work-os" — and let Cursor create `Active/`, `Projects/`, `Career/`, `Knowledge/`, and `Archive/` for you.

---

## Next Steps

Now that you're set up:

1. **Try the core workflows** — Morning planning, brain dumping, processing backlog
2. **Read your role guide** — Check `tutorials/` for role-specific workflows
3. **Explore use cases** — See `use-cases/` for advanced workflows (1:1 frameworks, career portfolio, etc.)
4. **Customize AGENTS.md** — Adjust AI behavior to match your preferences

---

## Additional Resources

- **Cursor Docs**: [cursor.com/docs](https://cursor.com/docs)
- **work-os Examples**: See [EXAMPLES.md](EXAMPLES.md) for real conversation examples
- **GitHub Repository**: [github.com/ahmadelswify/agentic-os](https://github.com/ahmadelswify/agentic-os)

---

**Questions?** Open an issue on GitHub or check the README FAQ.
