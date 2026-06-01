# Review Report: <task>

## Metadata

- Reviewer:
- Time:
- Source:
- Round:
- Sync document:
- Reused from previous round: yes | no
- If reused, prior verdict: Pass | Reject | Conditional pass
- Verdict: Pass | Reject | Conditional pass

## Worktree Status

- `git status --short --branch --untracked-files=all`:
- Working tree clean: yes | no
- Untracked files expected: list them and the reason

## HEAD / Tracking Branch / Remote Consistency

- `git rev-parse HEAD`:
- `git rev-parse origin/<branch>`:
- `git ls-remote origin refs/heads/<branch>`:
- All three equal: yes | no
- If no, explain the gap (ahead, behind, missing ref)

## Review Scope

- Files / modules reviewed:
- Change summary reviewed:
- Evidence reviewed:
- Out of scope:

## Verdict

Pass | Reject | Conditional pass

## Basis

- Change evidence:
- Verification evidence:
- Scope evidence:
- Risk evidence:

## Role-Boundary Violation Check

- Review Agent edited any file: yes | no
- Review Agent ran `git add` / `git commit` / `git push` / branch delete: yes | no
- Review Agent wrote to planning files or sync document: yes | no
- If any `yes` above: this round is `process-contaminated`. Stop, mark contaminated, request a fresh read-only Review Agent on the post-contamination state. Do not punish by rewriting history.

## Forbidden File Changes

- Files in the forbidden list of the latest handoff: changed | unchanged
- If changed, list paths and severity

## Self-Invalidating Evidence Risk

- Did Work or Main close out by writing "final HEAD = fixed SHA" into a document and committing it: yes | no
- Did the round rely on a documentation commit whose own SHA is the evidence: yes | no
- If yes, recommend live-command re-check instead of another evidence commit

## Historical Context vs Current Effective Guidance

- Did the sync document or planning files contain old wording that contradicts current effective guidance: yes | no
- If yes, did the latest round append a "current effective wording" entry instead of rewriting history: yes | no
- If no, recommend the append-only fix

## Findings

| Severity | Location | Issue | Required Fix |
|----------|----------|-------|--------------|
| Critical |          |       |              |
| Important |         |       |              |
| Minor |             |       |              |

## Conditions

Required only for conditional pass.

- Condition:
  - Owner:
  - Evidence required:
  - Re-review required: yes | no
  - Type: documentation-only | behavioral

## Reject Reason

Required only for reject.

- Blocking issue:
- Missing evidence:
- Scope/risk concern:
- Required next action:

## Residual Risk

- Not verified:
- Risk accepted by:
- Follow-up suggested:

## Close / Next Round Recommendation

Close | Continue next round | Pause | Request user decision
