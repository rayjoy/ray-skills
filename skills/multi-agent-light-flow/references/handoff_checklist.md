# Handoff Checklist: <task>

Use before sending work to another agent, tool, session, or reviewer.

## Required Context

- Task goal included
- Current round included
- Current status included
- Sync document path included
- Latest approved scope included
- Forbidden actions included
- Acceptance evidence included

## Allowed Files / Directories

List every path that the receiving agent may modify, including generated files and sync-document append entries. Use glob patterns when helpful. Example:

- `src/<area>/*`
- `tests/<area>/*`
- `docs/agent_sync/agent_sync_<task>.md` (append only)
- `.planning/<plan-id>/progress.md`, `findings.md`, `task_plan.md`

## Forbidden Files / Directories

List every path that must not be touched. Be explicit about design docs, planning files, secrets, and unrelated skills. Example:

- `docs/superpowers/specs/*.md` (design docs are Main-only)
- `skills/<other-skill>/*`
- secrets, `.env`, tokens

## Push / Publish

- `Push allowed`: yes | no (default: no for Work)
- `Push type allowed`: normal only | force allowed by explicit User approval (default: normal only)
- `After push`: report live commands only | append sync entry allowed (default: report live commands only)

If push is not allowed, Work must hand off to Main or User and stop.

## Reusable Review Agent Preference

- Preferred Review Agent name (if any): e.g. `Lagrange`
- Preferred Review Agent id (if any): e.g. `019e820b-8638-7103-88a4-eef128e24e43`
- Reuse rationale: saves context, keeps verdict style consistent

If no preference is named, Main picks a read-only Review Agent and records the choice in the sync document.

## Stop-After-Push

State explicitly what the receiving agent must do after push:

- Report live commands (`git status`, `git rev-parse`, `git ls-remote`, `git log`) in chat
- Do not append another documentation commit just to record the push
- Wait for User decision before any further closeout commit

## Non-Self-Invalidating Evidence

State how the receiving agent should record closure without re-invalidating the evidence:

- Use live commands, not fixed SHA
- Reference the commit that triggered the live re-check, not the SHA that the new commit produces
- If a sync entry is required, append without a final-HEAD line

## For Work Agent

Before execution, confirm:

- Sync document read
- Current status is `approved` or `executing`
- Task scope clear
- Allowed files / directories list read
- Forbidden files / directories list read
- Push policy read
- Reusable Review Agent preference read
- Stop-after-push instruction read
- Non-self-invalidating evidence rule read
- Verification evidence expected
- Stop conditions understood

Stop and request approval if:

- Goal changes
- Scope expands
- Risk increases
- Acceptance evidence changes
- Destructive/reset/bulk overwrite action needed
- High-risk path involved
- Root-cause direction changes
- Push is needed but not declared allowed

## For Review Agent

Before review, confirm:

- Latest sync document read
- Reviewed changes match current round
- Work report included
- Verification evidence included
- Scope statement included
- Residual risk included
- Read-only role confirmed: no edits, no commits, no push

Review verdict must be exactly one of:

- `Pass`
- `Reject`
- `Conditional pass`

For `Conditional pass`, list:

- Each condition with its owner, required evidence, and re-review requirement
- Whether each condition is documentation-only or behavioral

## For Main Agent

Before summarizing or closing, confirm:

- Latest Work entry read
- Latest Review entry read
- No unresolved conflict
- No pending change request
- No unclosed round
- User approval captured where required
- Live re-check needed for any documentation-only condition
- No new documentation commit is needed just to record a Pass

## For User

Before approving continuation, confirm:

- Goal still matches intent
- Scope/risk acceptable
- Evidence requirement clear
- Next agent/action clear
- Push policy still appropriate
