# work-os for Software Engineers

Ship reliably, communicate clearly, and grow your engineering skills with AI support.

## Why work-os for Software Engineering?

As a software engineer, you're juggling:
- **Delivery** — tickets, PRs, incidents, on-call, sprint commitments
- **Quality** — testing, tech debt, performance, security fixes
- **Collaboration** — code reviews, design discussions, stakeholder updates
- **Growth** — deepening technical skill, leveling up impact, building a portfolio

work-os helps you keep execution tight while turning your work into a career narrative.

---

## Setup for Software Engineers (10 minutes)

### 1. Define Your Goals

Open `GOALS.md` and add your objectives:

```markdown
# Goals

## This Quarter
1. Ship [project/feature] to production with [success metric]
2. Reduce [latency/error rate/build time] by [X]%
3. Improve reliability: close [X] top incidents / add alerts & runbooks
4. Career growth: build strength in [system design | infra | backend | frontend]

## Key Metrics
- Sprint reliability (commitment vs shipped)
- Incidents (count, severity, time-to-detect, time-to-resolve)
- Quality (bug rate, flaky tests, review turnaround)
- Engineering output (lead time, cycle time)

## Focus Areas
- Feature delivery
- Reliability & ops
- Technical debt
- Learning & career
```

### 2. Tell Cursor About Your Work

Describe your role and tech context so work-os can tailor categories:

```
You: "I'm a software engineer. I work on [backend/frontend/platform], do code reviews,
     handle on-call, and I'm currently focused on [project]."
```

Cursor will create a structure tailored to your engineering work:

```
Active/
├── sprint/            # This sprint’s committed work
├── bugs-incidents/    # Fixes, escalations, on-call follow-ups
├── tech-debt/         # Refactors, reliability, performance
├── reviews/           # PR reviews, design reviews, feedback to give
├── comms/             # Status updates, stakeholder asks
└── learning/          # Skill-building tasks and practice
```

---

## Daily Software Engineer Workflow

### Morning

```
You: "What should I work on today?"
```

Cursor will bias toward unblockers (incidents, high-impact tasks, review bottlenecks), then your sprint work.

### During Work

Capture quickly as things come up:

```
"Add to backlog: PR review needed for [repo/feature], blocking release"
"Add to backlog: Investigate flaky test in CI (started after last merge)"
"Add to backlog: Follow up on incident retro action items"
"Add to backlog: Design doc feedback requested by Thursday"
```

### End of Day

```
You: "Process my backlog"
```

Cursor will convert items into tasks, link them to goals, and surface blockers or stale work.

---

## Software-Engineer-Specific Workflows

### 1) Sprint Execution & Focus

Use work-os to keep sprint scope crisp:

```
You: "Help me pick 2-3 focus items for today based on impact and unblockers."
```

### 2) Code Review Throughput

Track reviews as first-class work so they don’t become hidden queues:

```
You: "Track my review queue and remind me of anything blocking others."
```

### 3) Reliability & Incident Follow-ups

Turn incident notes into actions and make sure the fixes land:

```
You: "Turn these incident notes into follow-up tasks and a short status update."
```

---

## What Counts as Urgent for Software Engineers

- Production incidents, security issues, customer-facing outages
- PR reviews that are blocking releases or teammates
- Time-sensitive stakeholder commitments (launch windows, demos)

## What Counts as Important for Software Engineers

- Tech debt that prevents velocity or reliability work
- Performance and cost improvements with measurable impact
- Design and architecture decisions that set direction
- Skill-building tied to your next level (scope, leadership, systems thinking)

---

## Skill Growth “Coach Mode” (use as an agent)

When you want feedback or training, prompt Cursor like you’re talking to a mentor:

### Career pathing
```
You: "Act as my Software Engineer coach. Based on my goals, what skills should I build next and what projects would prove them?"
```

### Leveling up impact
```
You: "Coach me on increasing my impact. Here’s what I shipped recently: [paste bullets]. What’s the next step to level up?"
```

### Technical decision practice
```
You: "Give me a system design drill for [topic], then grade my answer and suggest improvements."
```

---

## Related Resources

- [General Professional Guide](general-professional.md)
- [Professional Development Tracking](../use-cases/professional-development/README.md)
- [Career Portfolio](../use-cases/career-portfolio/README.md)
- [Project Tracking](../use-cases/project-tracking/README.md)

