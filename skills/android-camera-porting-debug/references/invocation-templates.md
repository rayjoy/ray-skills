# Invocation Templates

Use these templates to start a new session with enough context to trigger the correct workflow quickly.

## General Template

Use this for most Android camera tasks:

```text
Please use `android-camera-porting-debug` skill for this task.

Task type:
- new sensor porting / runtime diagnosis / image-quality issue / CamCal-OTP-EEPROM / metadata-provider-HAL / tuning-NVRAM
- this session is: [fill in]

Repository:
- [repo path]

Branch:
- [branch name]

Read first:
- [AGENTS.md or project rules]
- [task_plan.md]
- [findings.md]
- [progress.md]

Key files:
- [driver file]
- [metadata file]
- [CamCal or parser file]
- [other important files]

Current symptom:
- [symptom 1]
- [symptom 2]
- [symptom 3]

Current known conclusions:
- [confirmed fact 1]
- [confirmed fact 2]
- [current root-cause direction]

Important commits or changes:
- [commit 1]
- [commit 2]

Important logs or documents:
- [log directory]
- [PDF or reference doc]

Requirements:
- follow `Diagnose -> Decision Gate -> Execute -> Verify -> Document`
- do session catchup first
- provide conclusion, evidence, candidate explanations, and recommended next step
- do not widen the change scope without confirmation
```

## Session Continuation Template

Use this to continue multi-day work:

```text
Continue this Android camera task and use `android-camera-porting-debug` skill.

Working directory:
- [repo path]

Current branch:
- [branch name]

Read first:
- [AGENTS.md]
- [task_plan.md]
- [findings.md]
- [progress.md]

Current key files:
- [file 1]
- [file 2]

Current status:
- [fact 1]
- [fact 2]
- [main remaining problem]
- [current root-cause layer]

Important commits:
- [commit 1]
- [commit 2]

Please do session catchup first, then give the next minimal patch plan.
```

## New Sensor Porting Template

Use this when the main task is bring-up:

```text
Please use `android-camera-porting-debug` skill and help port a new Android camera sensor.

Repository:
- [repo path]

Platform or product:
- [SoC]
- [project or product]

Target sensor:
- [sensor name]
- [sensor id]
- [i2c address]
- [front or rear]

Available materials:
- [datasheet]
- [FAE driver]
- [OTP or EEPROM document]
- [reference sensor]

Current goal:
- complete minimal bring-up first
- acceptance criteria: compile success, probe success, app open

Please start with layered diagnosis and a minimal integration plan rather than broad code edits.
```

## Image-Quality Template

Use this when the main problem is visible image behavior:

```text
Please use `android-camera-porting-debug` skill and diagnose this Android camera image-quality issue.

Repository:
- [repo path]

Current symptom:
- red tint / green tint / blue tint / shading / brightness issue
- camera can already open
- [whether some modes are normal]

Important logs:
- [log directory]

Current known status:
- probe status
- metadata or provider status
- CamCal or OTP or EEPROM status
- tuning or NVRAM status

Requirements:
- first decide whether this is a calibration issue or a tuning issue
- then give the next minimal patch direction with evidence
```

## CamCal OTP EEPROM Template

Use this when the task is clearly calibration-chain focused:

```text
Please use `android-camera-porting-debug` skill and focus on the `camcal-otp-eeprom` path.

Repository:
- [repo path]

Sensor:
- [sensor name and id]

Current symptom:
- `ERR_NO_3A_GAIN` / `ERR_NO_SHADING` / `Read header ID fail` / zero gain / color cast

Available materials:
- [OTP or EEPROM document]
- [FAE reply]
- [related source files]
- [log directory]

Current known conclusions:
- storage type: [OTP / EEPROM / unknown]
- kernel read path: [working / broken / unknown]
- parser entry: [entered / not entered / unknown]

Requirements:
- determine whether the break is in storage, kernel mapping, layout/header, dispatch, parser, or consumer
- do not jump directly to tuning
```

## Recommended Fields

For best results, always include:

- repository path
- branch
- read-first files
- current symptom
- current known conclusions
- key logs

For continuation sessions, include:

- exact current root-cause layer
- last known good conclusion
- latest blocking point
