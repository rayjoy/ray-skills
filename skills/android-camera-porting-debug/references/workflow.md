# Workflow

## Default Flow

Always execute:

`Diagnose -> Decision Gate -> Execute -> Verify -> Document`

## Diagnose

- Identify the failing layer before editing.
- Collect the strongest available runtime evidence first.
- Separate symptom from root-cause candidate.

## Decision Gate

Choose one active root-cause layer:

- driver / probe
- metadata / provider / HAL
- calibration / CamCal / OTP / EEPROM
- AWB / LSC / 3A / tuning
- build / packaging / flash

Do not carry multiple unrelated root-cause paths in parallel unless evidence requires it.

## Execute

- Prefer minimal, reversible patches.
- Add logs before changing fragile logic.
- Avoid cross-layer simultaneous edits.

## Verify

- Compile success is not a runtime fix.
- Prefer runtime logs, symptom change, and error disappearance.

## Document

Record:

- current hypothesis
- evidence
- change made
- verification result
- next step
