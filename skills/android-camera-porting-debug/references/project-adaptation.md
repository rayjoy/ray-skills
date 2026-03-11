# Project Adaptation

Use this file only for project-specific knowledge.

Keep this file separate from general Android camera knowledge.

Examples:

- platform-specific paths
- build entrypoints
- product naming
- known repo conventions
- local logging shortcuts

## Example Project: Z400-H / MT6761

Use these notes only when working in a project with the same or very similar structure.

### Build Model

- split build flow: `vnd -> sys -> merge`
- `vnd` target: `vnd_tb8766p1_bsp_ztk`
- `sys` target: `sys_mssi_t_32_ago_ww`
- merged output directory:
  `/home/ray/source/Z400-H/sys/out_merged/target/product/tb8766p1_bsp_ztk/`

### Tracking Files

This project uses persistent planning files:

- `task_plan.md`
- `findings.md`
- `progress.md`

Update them continuously during multi-session camera work.

### Camera-Specific Working Rules

- treat `13M wrong max size`, metadata crash, and color cast as different layers unless evidence ties them together
- do not change `build.sh` defaults unless explicitly requested
- do not commit `.gitignore`
- when running `build.sh`, prefer feeding `q` as well to avoid stale interactive shell chains

### Useful Project Paths

Kernel sensor driver area:

- `vnd/kernel-4.19/drivers/misc/mediatek/imgsensor/src/...`

Kernel CamCal area:

- `vnd/kernel-4.19/drivers/misc/mediatek/cam_cal/src/...`

Project HAL sensor tuning area:

- `vnd/vendor/mediatek/proprietary/custom/mt6761/hal/imgsensor/...`

Project metadata area:

- `vnd/vendor/mediatek/proprietary/custom/mt6761/hal/imgsensor_metadata/...`

Common sensor metadata area:

- `vnd/vendor/mediatek/proprietary/custom/common/hal/imgsensor_metadata/sensor/...`

Project-level calibration parser area:

- `vnd/vendor/mediatek/proprietary/custom/tb8766p1_bsp_ztk/hal/imgsensor_src/...`

### Reusable Lessons From Z400-H

#### Lesson 1: Wrong max resolution may be metadata, not driver

In this project, a sensor could report the correct full size in driver logs while app-side max resolution still stayed at a lower default value.

Check:

- driver full size
- provider/static metadata
- project-specific metadata directory existence

#### Lesson 2: Metadata crash can come from missing common sensor tags

If project metadata exists but camera still aborts during static metadata construction, inspect common sensor metadata for required tags such as white level and sensitivity range.

#### Lesson 3: Red tint can be a calibration-chain problem, not a tuning-first problem

When logs show:

- `ERR_NO_3A_GAIN`
- `ERR_NO_SHADING`
- zero unit or golden gain

do not start from tuning. Inspect calibration dispatch first.

#### Lesson 4: Fixing kernel CamCal mapping may only move the failure up one layer

After kernel mapping is corrected, re-check whether:

- userspace parser runs
- parser logs appear
- layout recognition succeeds

Do not assume that a successful EEPROM read means calibration is fully integrated.

#### Lesson 5: Build evidence and runtime evidence must be reported separately

For this project, always distinguish:

- `vnd` compile success
- `merge` success
- artifact existence
- flash result
- runtime symptom result

Never collapse them into one “done” statement.
