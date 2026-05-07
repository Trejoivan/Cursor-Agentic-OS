# work-os for AI Engineers

Stay on top of experiments, evaluation, delivery, and responsible AI—while building real career leverage.

## Why work-os for AI Engineering?

As an AI engineer (or ML/LLM engineer), you’re managing:
- **Experimentation** — hypotheses, datasets, prompts, training runs, ablations
- **Evaluation** — metrics, regressions, test sets, qualitative reviews
- **Delivery** — integrations, latency/cost trade-offs, reliability, monitoring
- **Risk** — privacy, safety, bias, compliance, failure modes

work-os helps you track experiments and decisions, translate work into stakeholder-ready updates, and turn learning into a portfolio.

---

## Setup for AI Engineers (10 minutes)

### 1. Define Your Goals

Open `GOALS.md` and add your objectives:

```markdown
# Goals

## This Quarter
1. Improve model/task quality by [X]% on [metric] (and define baseline)
2. Reduce inference cost/latency by [X]% without quality regression
3. Ship [feature] with monitoring + eval gates
4. Career growth: strengthen [LLM systems | evaluation | data | MLOps]

## Key Metrics
- Quality: task success rate, precision/recall, win-rate, human eval
- Reliability: error rates, timeouts, rate limits, fallback rate
- Cost: $/request, tokens/request, infra spend
- Delivery: lead time, regression incidents

## Focus Areas
- Evaluation & benchmarking
- Prompting / fine-tuning / RAG
- Production reliability & monitoring
- Responsible AI
```

### 2. Tell Cursor About Your Work

```
You: "I'm an AI engineer. I work on LLM features, evaluation, and productionization
     (latency/cost/monitoring). Current focus: [project]."
```

Cursor will tailor categories like:

```
Active/
├── experiments/        # Hypotheses, runs, ablations, results
├── evaluation/         # Metrics, test sets, qualitative review, regressions
├── data/               # Data needs, labeling, quality issues
├── production/         # Integration, latency/cost, reliability, monitoring
├── risk-compliance/    # Privacy, safety, policy, security reviews
└── comms/              # Stakeholder updates, decision logs, launch notes
```

---

## Daily AI Engineer Workflow

### Morning
```
You: "What should I work on today?"
```

Cursor should bias toward unblockers (failed runs, eval regressions, production issues), then your highest-leverage experiment/evaluation work.

### During Work
Capture quickly:

```
"Add to backlog: Evaluation regression on [test] after change X — investigate"
"Add to backlog: New dataset needed for failure mode Y (examples + labeling plan)"
"Add to backlog: Cost spike after deploy — compare token usage baseline vs now"
"Add to backlog: Draft risk assessment for using tool Z / data source Q"
```

### End of Day
```
You: "Process my backlog"
```

---

## AI-Engineer-Specific Workflows

### 1) Experiment Log → Decision Log
```
You: "Turn these experiment notes into: hypothesis, method, results, conclusion, next experiment."
```

### 2) Evaluation Planning
```
You: "Help me design an evaluation plan for [feature]. Include: metrics, test set strategy, qualitative rubric, and regression gates."
```

### 3) Stakeholder-Ready Updates
```
You: "Write a short weekly update for leadership: progress, learnings, risks, next steps, and what decision we need."
```

---

## What Counts as Urgent for AI Engineers

- Production incidents/regressions (quality, safety, availability)
- Evaluation regressions blocking a launch
- Privacy/security/compliance issues that must be resolved before shipping

## What Counts as Important for AI Engineers

- Building reliable evaluation harnesses and test sets
- Reducing long-term cost/latency while preserving quality
- Documentation of decisions, failure modes, and mitigations
- Portfolio-worthy artifacts: benchmarks, system diagrams, impact write-ups

---

## Skill Growth “Coach Mode” (use as an agent)

### Guided learning + practice
```
You: "Act as my AI Engineer coach. Create a 6-week training plan for [LLM eval | RAG | fine-tuning | MLOps], with weekly drills and a capstone project."
```

### Failure-mode thinking
```
You: "Coach me: list likely failure modes for [feature], then ask me how I'd detect and mitigate each. Grade my answers."
```

### Career pathing
```
You: "Help me map my next role step in AI engineering. What signals should I build, and what projects prove them?"
```

---

## Related Resources

- [General Professional Guide](general-professional.md)
- [Professional Development Tracking](../use-cases/professional-development/README.md)
- [Career Portfolio](../use-cases/career-portfolio/README.md)
- [Project Tracking](../use-cases/project-tracking/README.md)

