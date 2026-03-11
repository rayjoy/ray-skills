# Metadata Provider HAL

## Scope

Use this file for:

- camera app open failure after probe succeeds
- wrong resolution
- metadata-dependent crash
- provider cannot enumerate the sensor
- static metadata or template request issues

## Main Checks

1. Confirm provider sees the sensor.
2. Confirm static metadata symbols and registration path.
3. Confirm required sensor metadata fields exist.
4. Confirm stream/resolution configuration matches driver capability.
5. Confirm app-open failures are not actually upstream probe failures.

## Typical Symptoms

- metadata missing
- provider symbol not found
- app flashes back or crashes on open
- sensor opens with wrong max resolution

## Execution Rules

- Fix required metadata gaps before tuning image quality.
- Do not treat provider open failure as a tuning issue.

## Practical Diagnosis Sequence

Use this sequence when probe is already successful:

1. Confirm the sensor is enumerated by provider or HAL.
2. Confirm camera characteristics or static metadata can be built.
3. Confirm sensor-specific metadata exists rather than silently falling back to common defaults.
4. Confirm the advertised stream or picture size matches driver capability.
5. If app crashes on open, identify whether the first failure is:
   - static metadata construction
   - template request metadata
   - provider enumeration
   - later pipeline startup

## Common Failure Patterns

### Pattern A: Driver full size is correct but app still shows lower max size

Symptoms:

- driver logs show expected full resolution
- app or framework still exposes a smaller max picture size
- no probe or sensor-ID error

Likely action:

- inspect project static metadata before touching driver timing or sensor mode tables

### Pattern B: Project metadata added, but app now crashes during open

Symptoms:

- provider begins to enumerate the sensor
- app crashes or `camerahalserver` aborts during metadata construction
- log references missing required sensor metadata tags

Likely action:

- inspect common sensor metadata in addition to project metadata

### Pattern C: Wrong issue layer selection

Symptoms:

- sensor probe is healthy
- provider open is unhealthy
- work starts drifting into tuning or CamCal too early

Likely action:

- finish metadata and provider closure first

## Evidence Priorities

Prefer these checks in order:

1. runtime provider enumeration
2. static metadata construction logs
3. actual exposed stream or BLOB size
4. app-open stability
5. image symptom after successful open

Do not treat “sensor can stream” as proof that metadata is correct.

## Static Metadata Guidance

Separate these layers:

- project-level metadata
- common sensor metadata
- request template metadata
- provider-side dynamic exposure of stream capability

If a sensor falls back to generic common metadata, resolution and capability exposure may look valid enough to open but still be capped or mismatched.

## Example: Resolution And Metadata Lessons

This case produced a reusable pattern:

1. Sensor driver reported the expected full size.
2. App still showed a lower maximum picture size.
3. Root cause was not driver full-size definition but missing sensor-specific project metadata.
4. After project metadata was added, a new crash appeared.
5. That second failure came from missing common sensor metadata, including required tags such as white level.
6. Once common sensor metadata was added, app open stabilized and the expected max picture size became visible.

Reusable lesson:

- if max size is wrong but probe is good, inspect metadata first
- if app crashes after metadata changes, inspect required common sensor tags
- solve metadata exposure before moving to image-quality diagnosis
