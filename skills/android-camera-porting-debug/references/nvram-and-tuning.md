# NVRAM And Tuning

## Scope

Use this file for:

- default tuning fallback
- tuning so loading
- NVRAM version or load behavior
- image quality issues after calibration path is proven healthy

## Main Checks

1. Is the correct tuning library loaded?
2. Is the correct sensor ID matched in tuning lookup?
3. Is NVRAM loaded or defaulted?
4. Are symptoms stable across modes and sessions?

## Execution Rules

- Treat tuning as a later-stage layer.
- Only move here after probe, metadata, and calibration layers are sufficiently proven.
