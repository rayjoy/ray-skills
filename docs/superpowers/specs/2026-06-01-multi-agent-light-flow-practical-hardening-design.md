# Multi-Agent Light Flow Practical Hardening Design

## Context

The `multi-agent-light-flow` skill worked for a long AndroidProjConfig wiki integration task, but the run exposed repeatable process gaps:

- Review agents can accidentally cross role boundaries.
- Conditional pass closure can create repeated handoff loops.
- Final evidence based on a fixed commit SHA can become stale as soon as documentation is committed.
- Push and closeout responsibilities need clearer handoff language.
- Reusable review agents save context, but the skill does not say when reuse is appropriate.

This update should keep the skill lightweight. It should strengthen the rules and templates without turning the flow into a heavy state machine.

## Goals

- Preserve the current simple flow: `Confirm -> Execute/Review/Revise loops -> Closeout`.
- Make Review Agent read-only constraints explicit and enforceable.
- Add guidance for conditional pass closure.
- Add a non-self-invalidating closeout rule.
- Improve handoff and review templates with fields that prevent scope drift.
- Add a Chinese example matching the Main / Work / Review / User collaboration pattern used in practice.

## Non-Goals

- Do not introduce a complex formal state machine.
- Do not require every task to use all fields.
- Do not remove the append-only sync document model.
- Do not require rewriting historical sync entries when they contain old or corrected statements.

## Proposed Changes

### 1. Strengthen Role Locks

Update `SKILL.md` so `Review` says:

- Review must inspect only.
- Review must not modify files.
- Review must not commit.
- Review must not push.
- If Review performs a write action, the record must be treated as process-contaminated until Main/User decides how to handle it.

Clarify `Main`:

- Main may write planning, handoff, and sync records.
- Main should not implement task deliverables when Work Agent owns execution.
- Main should avoid committing extra closeout records after a final live review has passed unless the User explicitly wants that record committed.

### 2. Add Conditional Pass Closure Guidance

Add a short section to `SKILL.md`:

- A conditional pass must list owner, required evidence, and whether re-review is required.
- Work closes only the named conditions.
- Main routes the closure back to Review when re-review is required.
- If the only remaining condition is documentation freshness caused by a documentation commit, prefer live command verification over another evidence commit.

### 3. Add Non-Self-Invalidating Closeout

Add a rule:

- Do not use "final HEAD = fixed SHA" as the only closeout condition when the act of documenting that evidence creates a new commit.
- Prefer live verification commands:
  - `git status --short --branch --untracked-files=all`
  - `git rev-parse HEAD origin/<branch>`
  - `git ls-remote origin refs/heads/<branch>`
- If live verification passes and the only remaining work is to record that pass in the repo, default to stopping rather than creating a new commit.

### 4. Clarify Push / Publish Boundary

Add handoff fields for:

- `Push allowed: yes | no`
- `Push type allowed: normal only | force allowed by explicit User approval`
- `After push: report live commands only | append sync entry allowed`

This keeps push separate from normal closeout and avoids accidental force push or repeated evidence commits.

### 5. Expand Handoff Checklist

Update `references/handoff_checklist.md` with:

- Allowed files / directories
- Forbidden files / directories
- Push allowed
- Reusable review agent preference
- Stop-after-push instruction
- Non-self-invalidating evidence instruction

### 6. Expand Review Report Template

Update `references/review_report_template.md` with checks for:

- Worktree status
- `HEAD` / tracking branch / remote ref consistency when relevant
- Role-boundary violations
- Forbidden file changes
- Self-invalidating evidence risk
- Whether old incorrect text is historical context or current effective guidance

### 7. Add Chinese Usage Example

Update `references/usage_examples_zh.md` with a concise example:

- Main writes handoff to sync doc.
- Work executes approved scope and normal pushes if allowed.
- Review performs read-only live checks and returns Pass.
- Main stops after Pass when another committed closeout would only move HEAD again.

## Files To Change

- `skills/multi-agent-light-flow/SKILL.md`
- `skills/multi-agent-light-flow/references/handoff_checklist.md`
- `skills/multi-agent-light-flow/references/review_report_template.md`
- `skills/multi-agent-light-flow/references/usage_examples_zh.md`

## Acceptance Criteria

- The skill still reads as a light process, not a heavyweight workflow engine.
- Review read-only rule is unambiguous.
- Handoff template makes execution ownership and forbidden scope clear.
- Review template catches role violations and self-invalidating closeout loops.
- Chinese example covers the practical Main / Work / Review / User pattern.
- No unrelated skills are changed.

## Open Decisions

- Keep status values unchanged for now. Use text fields for `process-contaminated`, push state, and closeout state instead of adding new statuses.
- Keep sync documents append-only. Correct old statements by appending current effective guidance, not by rewriting history.
