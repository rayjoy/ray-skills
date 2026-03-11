# Build Verify Document

## Scope

Use this file for:

- split build flow
- merge readiness
- package verification
- flash verification
- session progress recording

## Build Rules

- Distinguish compile evidence from runtime evidence.
- If only `vnd` changed, confirm whether `sys` rebuild is truly unnecessary.
- Verify merge inputs before assuming package correctness.

## Verification Rules

Report separately:

- compile result
- merge result
- artifact existence
- flash result
- runtime log result

## Documentation Rules

When project tracking files exist, update:

- `task_plan.md`
- `findings.md`
- `progress.md`

Record the exact current root-cause hypothesis and next step.
