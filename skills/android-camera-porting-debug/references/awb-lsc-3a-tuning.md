# AWB LSC 3A Tuning

## Scope

Use this file for:

- red tint
- green tint
- blue tint
- shading issues
- suspicious AWB gain behavior
- image quality issues after camera opens normally

## Main Checks

1. Are unit and golden gains non-zero?
2. Is shading data present and accepted?
3. Is symptom calibration-driven or tuning-driven?
4. Did AWB fallback to defaults?
5. Is the issue global or mode-specific?

## Typical Symptoms

- red image with zero unit and golden gain
- shading error with readable sensor stream
- image opens but color is consistently wrong

## Execution Rules

- Rule out CamCal path before blaming tuning.
- Do not change tuning first when logs show calibration failure.

## Practical Diagnosis Sequence

Use this order for image-quality symptoms:

1. Confirm the camera opens and streams stably.
2. Confirm whether the issue is global or mode-specific.
3. Check calibration-related logs:
   - `ERR_NO_3A_GAIN`
   - `ERR_NO_SHADING`
   - zero unit or golden gain
4. Check whether AWB or shading data is falling back to defaults.
5. Only after calibration path is sufficiently proven should you move to tuning-specific adjustments.

## Symptom Mapping

### Red Tint

Check first:

- unit and golden gain values
- AWB calibration dispatch
- whether AWB is running with default gains

Do not start from tuning when calibration logs are already bad.

### Shading Error

Check first:

- LSC payload presence
- parser or layout dispatch
- whether shading table is accepted by upper layers

### Stable But Wrong Color

If the stream is stable and only color is wrong, decide whether the issue is:

- calibration missing
- calibration present but not consumed
- tuning mismatch after calibration is healthy

## Common Failure Patterns

### Pattern A: Zero gains plus strong color cast

Symptoms:

- `UnitGain(0, 0, 0)`
- `GoldenGain(0, 0, 0)`
- strong red, green, or blue tint

Likely action:

- stay in calibration path
- do not start with tuning library edits

### Pattern B: Shading error and color cast together

Symptoms:

- `ERR_NO_SHADING`
- `ERR_NO_3A_GAIN`
- visible image cast or uneven shading

Likely action:

- inspect shared calibration chain rather than treating AWB and LSC separately at first

### Pattern C: Calibration chain unhealthy but tuning is blamed too early

Symptoms:

- sensor opens
- image looks wrong
- logs already show calibration failure

Likely action:

- postpone tuning work until calibration path is proven or ruled out

## Tuning Boundary Rules

Treat tuning as the active root-cause layer only when most of the following are true:

- sensor probe is good
- metadata exposure is good
- camera opens normally
- calibration dispatch is proven
- gains or shading data are non-zero or known-good
- image symptom still remains

If these are not true, the task is probably not yet in the tuning layer.

## Example: Color-Cast Lessons

This case produced a reusable pattern:

1. Camera could open and the correct max resolution was restored.
2. The remaining visible symptom was a red tint.
3. Logs still showed:
   - `ERR_NO_3A_GAIN`
   - `ERR_NO_SHADING`
   - zero unit and golden gain
4. That proved the problem had not yet reached pure tuning territory.
5. The correct next step was calibration-chain diagnosis, not immediate tuning adjustment.

Reusable lesson:

- “camera opens” does not mean “image-quality path is healthy”
- when gain and shading logs are broken, stay in calibration before touching tuning
