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

The flow stays light. Do not turn it into a heavy state machine. Do not add new status enums beyond the existing `draft | approved | executing | pending_review | closed`. Use prose to describe process states such as `process-contaminated` or `non-self-invalidating closeout`.

## Role Locks

- `Main`: clarify problem, scope, plan, sync, summarize, and close out. In multi-agent tasks, Main does not execute task deliverable changes. Main may write planning files, handoff entries, and sync-document records. After a live review has passed, Main should avoid creating new commits that only record the pass. Stop and let the live evidence stand.
- `Work`: execute approved task scope, produce evidence, and stop on scope or risk changes. Work may commit. Work may not push unless the handoff explicitly says push is allowed.
- `Review`: inspect changes and evidence, give a verdict, and **do not modify any file**. Read-only applies to file edits, `git add`, `git commit`, `git push`, branch deletion, and any write to planning files. If Review writes anything to disk, that record is treated as `process-contaminated` and must be re-issued by Main or Work after a User decision. Do not punish Review by rewriting history; just mark and re-run.
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
- Old wording that conflicts with the current effective rule is fixed by appending a "current effective wording" entry. Do not rewrite history.

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

### Review Read-Only Rules

Review Agent must:

- Inspect files and run read-only commands.
- Return one verdict: `Pass`, `Reject`, or `Conditional pass`.
- Reuse the previously named Review Agent when the sync document names one, to save context.

Review Agent must not:

- Edit any file (including planning files and the sync document).
- Run `git add`, `git commit`, `git push`, branch delete, or force push.
- Stage or move worktree files on behalf of Work or Main.

If a Review Agent commits, edits files, or pushes anyway, Main or Work must mark that record `process-contaminated` in the next sync entry and stop relying on it. A new read-only Review Agent must re-issue the verdict on the post-contamination state. Do not rewrite history; keep the contaminated commit visible so the audit trail is intact.

## Conditional Pass Closure

A `Conditional pass` must list, in the sync document or handoff:

- Owner who closes each condition (usually Work).
- Required evidence for each condition.
- Whether re-review is required.
- Whether the condition is documentation-only (a written update that does not need re-review) or behavioral (a code/branch state that does).

Work only closes the named conditions. Work does not re-open the rest of the verdict.

If the only remaining condition is "the live SHA in the previous doc just shifted because of a documentation commit", prefer a live-command re-check over another documentation commit. Re-submitting evidence that itself moves HEAD creates an infinite loop and is not a valid closure path.

Re-review path:

- Documentation-only condition and live re-check already passes: Main records the closure and may skip re-review.
- Behavioral condition: Main hands the closure back to Review for a fresh verdict.

## Non-Self-Invalidating Closeout

Do not close out by writing "final HEAD = fixed SHA" into a document and then committing that document. The commit itself moves HEAD and invalidates the evidence on the next read.

Prefer live verification commands recorded by Review or in chat, not in the commit:

```bash
git status --short --branch --untracked-files=all
git rev-parse HEAD origin/<branch>
git ls-remote origin refs/heads/<branch>
```

Closure rules:

- If live verification passes and the only remaining work is "write the pass result into the repo", stop. Let the live evidence stand. Do not create a new documentation commit just to record that the live check passed.
- If a sync-document entry is needed, append it without referencing a fixed SHA. Refer to the live check time or the commit that triggered the re-check.
- If a closeout commit is genuinely required (for example, to flip a status flag in a planning file), keep it small, document the trigger, and expect a follow-up live re-check.

## Push / Publish Boundary

Push is a separate action from closeout. The handoff must declare:

- `Push allowed`: `yes` or `no`. Default `no` for Work.
- `Push type allowed`: `normal only` or `force allowed by explicit User approval`. Default `normal only`.
- `After push`: `report live commands only` or `append sync entry allowed`. Default `report live commands only`.

Default behavior if the handoff is silent:

- Work may commit but must not push.
- After Work commits, Work appends a Work Report to the sync document or chat. Do not push the report itself unless push is explicitly allowed.
- After push, Work or Main reports live command output. Do not append a new documentation commit just to record the push.

Never force-push, rewrite history, delete branches, or close source PRs without explicit User approval. Even if Review passes, push is not part of the verdict.

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

After Review Pass:

- If a push is allowed and has been performed, Work or Main reports live commands in chat. No further commits are required.
- If a sync entry is needed to mark the round closed, append it without a fixed SHA.

## Handoff

Before handing work to another agent, tool, session, or reviewer, use `references/handoff_checklist.md` unless project rules provide a stricter checklist.

For ready-to-copy prompts for Main, Work, and Review agents, see `references/usage_examples.md` or `references/usage_examples_zh.md`.
