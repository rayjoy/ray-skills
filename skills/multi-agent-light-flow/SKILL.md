---
name: multi-agent-light-flow
description: Use when a task involves multiple agents, separated execution and review, cross-session or cross-tool handoff, approval checkpoints, evidence-gated work, or explicit Main/Work/Review/User coordination across any project type.
---

# Multi-Agent Light Flow

Use this skill to keep multi-agent work coherent when planning, execution, review, and approval may happen in separate contexts.

## When to Use

Use for:

- Multi-agent or subagent collaboration.
- Separate execution and review roles.
- Work handed across sessions, tools, chats, tickets, or repositories.
- Tasks needing explicit approval, evidence, or change control.
- Any project type where context loss or role drift would create risk.

Do not use for simple one-shot answers or tiny edits that need no handoff, no review loop, and no approval checkpoint.

## Core Flow

```text
Confirm -> Execute/Review/Revise loops -> Closeout
```

## Role Locks

- `Main`: clarify problem, scope, plan, sync, summarize, and close out. In multi-agent tasks, Main does not execute task deliverable changes.
- `Work`: execute approved task scope, produce evidence, and stop on scope or risk changes.
- `Review`: inspect changes and evidence, give a verdict, and avoid modifying the work.
- `User`: approve, route cross-context information, decide conflicts, and approve high-risk or publishing actions.

## Project Override

Before starting, look for project or shared collaboration docs. Known names may include:

- `AGENTS.md`
- `CLAUDE.md`
- `multi-agent`
- `agent_sync`
- `collaboration`
- `多Agent协作开发流程规范.md`
- `多Agent协作开发流程_最简启动手册.md`
- `多Agent工程任务轻流程_报告模板与证据门禁.md`

Follow stricter or more specific local rules when present. If none exist, use this skill's default rules and templates.

## Sync Document

Use one sync document per task:

```text
agent_sync_<task>.md
```

Recommended location:

```text
docs/agent_sync/
```

Project rules may override location.

Rules:

- Append only.
- Do not overwrite another agent's record.
- Each entry includes author, time, source, and status.
- Status values: `draft | approved | executing | pending_review | closed`.
- Work may execute only `approved` or `executing` task segments.
- Conflicts stay visible until User decides.

Use `references/agent_sync_template.md` when no project template exists.

## Minimum Confirm Package

Before Work starts, define:

- Problem
- Scope
- Forbidden actions
- Acceptance evidence

## Review Verdicts

Review result must be one of:

- `Pass`
- `Reject`
- `Conditional pass`

Review must inspect change evidence, verification evidence, scope, and residual risk. Use `references/review_report_template.md` when no project template exists.

## Change Control

Stop and request User approval when:

- Goal changes.
- Scope expands.
- Risk increases.
- Acceptance evidence changes.
- Destructive, reset, or bulk overwrite action is needed.
- High-risk path is involved.
- Root-cause direction changes.

## Closeout

Closeout requires:

- Review pass, or conditional pass fully closed.
- No unresolved conflict.
- No pending change request.
- No unclosed execution/review round.

Closeout is not commit, push, deploy, merge, release, or cleanup. Those actions need separate explicit User approval.

## Handoff

Before handing work to another agent, tool, session, or reviewer, use `references/handoff_checklist.md` unless project rules provide a stricter checklist.

For ready-to-copy prompts for Main, Work, and Review agents, see `references/usage_examples.md` or `references/usage_examples_zh.md`.
