# Usage Examples

These prompts are examples. Adapt task names, paths, approval wording, and project rules before use.

## Start a New Task as Main

```text
[$multi-agent-light-flow]

Act as Main Agent for this task:
<task summary>

Do not execute task deliverable changes yet.

First enter the Confirm phase and produce the minimum confirm package:
1. Problem
2. Scope
3. Forbidden actions
4. Acceptance evidence

Create or update one sync document:
docs/agent_sync/agent_sync_<task>.md

Use draft status until User explicitly approves the execution scope.
```

## Send Work to a Work Agent

```text
[$multi-agent-light-flow]

You are Work Agent.

Task:
<task summary>

Sync document:
docs/agent_sync/agent_sync_<task>.md

First read:
1. Project instructions, if any
2. The sync document
3. The latest approved or executing round

Rules:
- Execute only if current status is approved or executing.
- Modify only files within approved scope.
- Do not perform forbidden actions.
- If goal, scope, risk, or acceptance evidence must change, stop and append a Change Request.
- After execution, append a Work Report with:
  1. What Changed
  2. Why
  3. Evidence
  4. Scope Statement
  5. Risks / Not Verified
  6. Review Request
```

## Ask Work Agent to Check Readiness First

```text
[$multi-agent-light-flow]

You are Work Agent. Do not modify files yet.

Read:
docs/agent_sync/agent_sync_<task>.md

Only report:
1. Current status
2. Whether execution is allowed
3. Approved scope
4. Forbidden actions
5. Files you expect to modify
6. Questions or blockers
```

## Send Work to a Review Agent

```text
[$multi-agent-light-flow]

You are Review Agent.

Task:
<task summary>

Sync document:
docs/agent_sync/agent_sync_<task>.md

Review the latest Work Report, changed files, verification evidence, scope statement, and residual risk.

Do not modify files.

Return one verdict:
Pass | Reject | Conditional pass

Use this structure:
1. Verdict
2. Evidence checked
3. Findings
4. Conditions, if any
5. Re-review required: yes | no
6. Residual risk
7. Close / next round recommendation
```

## Example: Adapt a New LCD Panel

Main Agent start:

```text
[$multi-agent-light-flow]

Act as Main Agent for adapting a new LCD panel:
axs15260_wvga_dsi_hxj

Do not modify code yet.

First produce the minimum confirm package:
1. Problem
2. Scope
3. Forbidden actions
4. Acceptance evidence

Create or update:
docs/agent_sync/agent_sync_axs15260_wvga_dsi_hxj.md

This task may later require Work Agent changes to panel parameters, driver integration, display configuration, or build configuration. Review Agent must inspect diff and verification evidence.
```

Possible confirm package:

```md
# Confirm Package

## Problem

Adapt new LCD panel `axs15260_wvga_dsi_hxj` so the target project can recognize and bring up the panel.

## Scope

- Panel driver or panel parameter files
- Display configuration entry points
- Required build configuration
- Build logs and display-related runtime logs

## Forbidden Actions

- Do not switch target product or project.
- Do not change unrelated panels.
- Do not change default build target.
- Do not delete, reset, or bulk overwrite files.
- Do not commit ignored or unrelated files.

## Acceptance Evidence

- Relevant diff
- Build or partial build evidence
- Display or boot logs
- Panel bring-up result or failure evidence
- Review verdict
```

Work Agent prompt:

```text
[$multi-agent-light-flow]

You are Work Agent.

Task:
Adapt LCD panel axs15260_wvga_dsi_hxj.

Sync document:
docs/agent_sync/agent_sync_axs15260_wvga_dsi_hxj.md

First read project instructions and the sync document.

Execute only if the current round is approved or executing.

Only modify approved panel/display/build-scope files. If required scope expands or verification evidence must change, stop and append a Change Request instead of continuing.

After execution, append a Work Report with What Changed, Why, Evidence, Scope Statement, Risks / Not Verified, and Review Request.
```

## Example: Fix a Build Failure

```text
[$multi-agent-light-flow]

Act as Main Agent for fixing this build failure:
<paste short error summary>

Do not modify code yet.

Create or update:
docs/agent_sync/agent_sync_fix_build_failure.md

Confirm:
1. Problem
2. Scope
3. Forbidden actions
4. Acceptance evidence

Acceptance evidence should include the failing command, relevant log excerpt, changed files, and rerun result.
```
