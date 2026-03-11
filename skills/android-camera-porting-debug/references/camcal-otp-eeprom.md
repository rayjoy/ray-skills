# CamCal OTP EEPROM

## Scope

Use this file for:

- calibration read failure
- OTP vs EEPROM uncertainty
- layout/header mismatch
- parser dispatch failure
- `ERR_NO_3A_GAIN`
- `ERR_NO_SHADING`
- `Read header ID fail`

## Standard Chain

`storage -> kernel read path -> userspace dispatch -> layout/header check -> parser -> AWB/LSC/AF consumer`

## Main Questions

1. Is calibration stored in OTP or external EEPROM?
2. Is the kernel read mapping present?
3. Does runtime actually hit the storage read path?
4. Does layout/header recognition succeed?
5. Does parser function actually execute?
6. Do parsed gains or shading values become non-zero?

## Typical Failure Split

- kernel mapping missing
- wrong EEPROM slave address
- wrong layout/header assumption
- parser not entered
- parser entered but offset/layout wrong
- parser correct but upper layer still not consuming data

## Execution Rules

- Do not blind-edit layout tables without evidence of storage type and map when those facts are still unknown.
- If parser logs do not appear, stop editing parser internals and inspect dispatch/layout first.

## Practical Decision Tree

Use this sequence for calibration issues:

1. Confirm the symptom is calibration-shaped:
   - color cast
   - `ERR_NO_3A_GAIN`
   - `ERR_NO_SHADING`
   - `UnitGain(0, 0, 0)`
   - `GoldenGain(0, 0, 0)`
2. Confirm runtime actually reaches the calibration stack.
3. Confirm storage type:
   - internal OTP
   - external EEPROM
4. Confirm kernel read path:
   - sensor ID match
   - device ID match
   - slave address match
   - read callback present
5. Confirm userspace dispatch:
   - layout/header recognition
   - target parser function actually entered
6. Only after parser entry is proven should you adjust parser offsets or payload interpretation.

## Evidence Priorities

Use evidence in this order:

1. Vendor or FAE document confirming storage type and map
2. Runtime kernel read logs
3. Runtime userspace dispatch logs
4. Parsed gain or shading values
5. Image symptom change

Do not skip directly from image symptom to tuning or parser edits when storage and dispatch are still unproven.

## Common Failure Patterns

### Pattern A: Kernel mapping missing

Symptoms:

- runtime reaches `CAM_CALIOC_G_READ`
- lower layer reports missing command info or null read callback
- userspace never receives valid payload

Likely action:

- inspect kernel calibration list and sensor-to-slave-address mapping

### Pattern B: Kernel mapping fixed but gains still zero

Symptoms:

- runtime shows calibration read activity
- `ERR_NO_3A_GAIN` persists
- `UnitGain` and `GoldenGain` stay zero

Likely action:

- inspect userspace parser layout and offsets

### Pattern C: Parser patch added but parser logs never appear

Symptoms:

- generic calibration entry logs appear
- parser-specific logs do not appear
- error returns immediately

Likely action:

- inspect layout selection or header recognition before parser internals

This is a critical rule: if parser logs do not appear, the bug is upstream of parser payload decoding.

## Layout/Header Guidance

Many MTK projects assume a header-driven layout:

- read 4-byte header from one or more candidate addresses
- match against known layout IDs
- set `LayoutType`
- dispatch by command to the corresponding parser

If the vendor map does not contain this style of header, a project may need:

- a sensor-specific layout override
- a sensor-specific dispatch shortcut
- or a special-case path in layout check

Do not assume EEPROM readability implies parser reachability.

## Example: SC1620CS Lessons

This case produced a reusable pattern:

1. Vendor document proved `SC1620CS` used external EEPROM and gave:
   - EEPROM type
   - slave address
   - AWB and LSC map
2. Kernel calibration mapping was missing, so runtime could not enter the normal read path.
3. Adding the sensor mapping fixed kernel access.
4. Runtime then showed calibration reads happening, but userspace still returned `ERR_NO_3A_GAIN`.
5. A parser-offset patch was added, but parser-specific logs never appeared.
6. This proved the real block had moved further up to layout recognition.

Reusable lesson:

- first prove storage
- then prove kernel read
- then prove dispatch
- then prove parser entry
- only then adjust offsets
