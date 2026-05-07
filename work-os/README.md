# work-os: AI-Native Productivity for Any Professional

> Brain dump naturally. AI organizes everything. You keep working.

A Cursor-driven productivity workspace where you talk to the AI instead of filling out forms. Open the workspace, ask in natural language, and Cursor handles the structure.

## About This Fork

This is my attempt at adapting a pre-existing **Claude Code** agentic OS workflow into a **Cursor-compatible** process (local-first markdown + `AGENTS.md` + `.cursor/rules`). The goal is to keep the spirit of the original approach while making it work cleanly inside Cursor.

## How It Works

1. **Brain dump** into BACKLOG.md throughout your day
2. **Say "process backlog"** to Cursor
3. **Cursor organizes everything** into structured tasks, projects, and priorities
4. **Work naturally** by asking "what should I work on today?"

No manual categorization. No form-filling. No app-switching.

## Quick Start

Requires [Cursor](https://cursor.com).

1. Clone the repo and open it in Cursor.

   ```bash
   git clone https://github.com/ahmadelswify/agentic-os.git
   ```

2. In Cursor, point a chat at `agentic-os/work-os/` and say:

   ```text
   Help me set up work-os
   ```

Cursor reads `AGENTS.md`, asks about your role, builds your personalized structure, and gets you started.

**New to Cursor?** See [SETUP.md](SETUP.md) for a step-by-step guide.

## Your Daily Workflow

**Morning:**
```
"What should I work on today?"
```
Cursor reviews your tasks and goals to suggest priorities.

**During Work:**
```
"Add to backlog: Follow up with Sarah about the renewal"
"Add to backlog: Draft script for next week's video"
"Add to backlog: Review the vendor contract"
```

**End of Day:**
```
"Process my backlog"
```
Cursor organizes everything into tasks with priorities and context.

**Weekly:**
```
"Run my weekly review"
```
Cursor helps you reflect, track progress, and plan ahead.

## How Is This Different?

| | Traditional Tools | work-os |
|---|---|---|
| **Input** | Forms, fields, clicks | Natural conversation |
| **Organization** | Manual categories + tags | AI handles it automatically |
| **Daily planning** | Open app, scan board | "What should I work on?" |
| **Capture speed** | Switch apps, fill fields | "Add to backlog: ..." |
| **Maintenance** | Weekly cleanup sessions | Zero maintenance |
| **Data** | Cloud-dependent | Local files on your machine |

## Adapts to Any Role

Start here, then choose the guide that fits your work:

- **[Getting Started](tutorials/getting-started.md)** — 15-minute setup for everyone
- **[Software Engineer](tutorials/software-engineer.md)** — Sprint execution, reviews, reliability, skill growth
- **[Technical Product Manager](tutorials/technical-product-manager.md)** — Decisions, alignment, delivery comms, impact
- **[Solutions Manager](tutorials/solutions-manager.md)** — Discovery → scope, implementation plans, escalations
- **[AI Engineer](tutorials/ai-engineer.md)** — Experiments, evaluation, productionization, responsible AI
- **[Content Creator](tutorials/content-creator.md)** — Scripts, feedback, performance tracking
- **[University Professor](tutorials/university-professor.md)** — Research, teaching, advising, grants
- **[Operations Manager](tutorials/operations-manager.md)** — Processes, vendors, incidents
- **[Customer Success](tutorials/customer-success.md)** — Accounts, renewals, customer health
- **[Marketing](tutorials/marketing.md)** — Campaigns, content, launches
- **[General Professional](tutorials/general-professional.md)** — Works for any role

## Directory Structure

Your structure adapts to your role. Here's the base:

```
work-os/
├── AGENTS.md            # AI instructions (the map)
├── BACKLOG.md           # Your brain dump inbox
├── GOALS.md             # Your objectives
├── docs/                # The harness — agent instructions, workflows,
│   │                    #   validation rules, and cleanup processes
│   ├── golden-principles.md
│   ├── agent-instructions/
│   ├── workflows/
│   ├── validation/
│   └── garbage-collection/
├── workflows/           # Specialized workflow references for Cursor
├── Active/              # Current work (organized by YOUR categories)
├── Projects/            # Multi-task initiatives
├── Career/              # Professional development
├── Knowledge/           # Reference materials
└── Archive/             # Completed work
```

The `Active/` folder is personalized during setup based on your role. The `docs/` folder is the harness — structured instructions Cursor reads on-demand instead of loading everything at once. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for how all pieces connect.

## See It in Action

```
You: "Add to backlog: Client wants to discuss expanding the project scope,
      need to prep talking points for Thursday"

You: "Process backlog"

Cursor: Created task: 'Prep talking points for client scope discussion'
        - Marked as important (meeting Thursday)
        - Category: client-work
        - Connected to: Q1 expansion goal

You: "What should I work on today?"

Cursor: Here's your focus for today:

        Urgent:
        • Prep talking points for client scope discussion (Thursday meeting)
        • Finish the draft proposal (client waiting)

        If you have time:
        • Review last month's project metrics

        You're in good shape — two things need attention today.

You: "Done with the client prep"

Cursor: Nice! Marked as done.
        That meeting could be portfolio-worthy if the scope expands —
        want me to track it?
```

Notice what happened: you brain dumped one sentence, Cursor structured it into a task connected to your goals, then proactively offered to track it as a career accomplishment. That's the difference between a to-do list and a system that works for you.

## Real-World Use Cases

- **[1:1 Meeting Prep](use-cases/1-on-1-frameworks)** — Track threads, log accomplishments, prepare talking points
- **[Professional Development](use-cases/professional-development)** — Skills, courses, career milestones
- **[Project Tracking](use-cases/project-tracking)** — Cross-functional initiatives, stakeholders, deliverables
- **[Career Portfolio](use-cases/career-portfolio)** — Accomplishment logs, project summaries, interview stories
- **[Meeting Notes](use-cases/meeting-notes)** — Process meetings into action items and decisions

## Common Cursor Prompts

work-os responds to natural language — there are no slash commands required:

| Prompt | What happens |
|--------|--------------|
| "Help me set up work-os" | Personalize your workspace (~5 min) |
| "What should I work on today?" | Morning planning: 2-4 focus items |
| "Process my backlog" | Turn brain dumps into organized tasks |
| "Run my weekly review" | Reflect on the week: wins, progress, what's next |
| "Add a task: …" | Quickly capture a task |
| "Prep me for my meeting with [name]" | Gather context and talking points |
| "Log this accomplishment: …" | Record a win for your career tracker |
| "Generate a status report for [project]" | Stakeholder-ready project update |

The full list of workflow references lives in `workflows/`.

## Requirements

- **[Cursor](https://cursor.com)** — AI-native code editor that reads `AGENTS.md` and `.cursor/rules` automatically.

See [SETUP.md](SETUP.md) for detailed installation instructions.

## FAQ

**Q: Do I need Cursor specifically?**
A: This template is configured for Cursor's `AGENTS.md` + `.cursor/rules` workflow. Other AI editors that respect those conventions will mostly work, but Cursor is the supported path.

**Q: How is this different from Notion/Asana/Jira?**
A: Those require manual input and context-switching. work-os is conversational. You brain dump, Cursor organizes. You never leave the editor.

**Q: Will my data stay private?**
A: Yes. Everything stays as local files on your computer. Nothing is uploaded unless you choose to back up to GitHub.

**Q: Can I use this for personal tasks, not just work?**
A: Absolutely. The structure adapts to whatever you need. Some users track personal goals, side projects, and career development alongside work.

**Q: What roles work best with this?**
A: Any professional role. See [Adapts to Any Role](#adapts-to-any-role) for specific guides.

## Community

- **[Landing Page](https://work-os.rizq.build)** — Interactive demo and setup
- **[Discord](https://discord.gg/GKg8TGmA)** — Join builders using AI-native productivity
- **[LinkedIn](https://www.linkedin.com/in/swify/)** — Follow for tips and updates
- **Newsletter:** "Work Smarter with AI" on LinkedIn

## Contributing

Found this helpful? Have ideas? Open an issue or PR.

<details>
<summary><strong>The Story Behind work-os</strong></summary>

I tried Notion. I tried Todoist. I even tried GTD, bullet journaling, and every productivity "system" out there.

The pattern was always the same: Week 1, excited. Week 2, customizing. Week 3, spending more time organizing than working. Week 4, back to scattered notes.

Productivity systems became my biggest productivity drain.

So I built something different: let AI handle the system while you handle the work. Brain dump. AI organizes. You keep working. No setup overhead. No maintenance burden. No productivity theater.

</details>

## License

MIT — Use it however you want

---

**Created by Ahmad Elswify** • [LinkedIn](https://www.linkedin.com/in/swify/)

**Contributors:**
- Yusef Khedr, Software Engineer
