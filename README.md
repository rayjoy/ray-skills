# ray-skills

Personal Codex and agent skills stored in a standalone Git repository.

中文说明见 [README.zh-CN.md](./README.zh-CN.md).

## Overview

This repository is used to:

- version personal skills outside the local runtime directory
- review and evolve skills in a normal Git workflow
- sync reusable skills across machines
- keep project-specific work separate from reusable guidance

## Repository Layout

```text
ray-skills/
├── README.md
├── README.zh-CN.md
└── skills/
    └── <skill-name>/
        ├── SKILL.md
        ├── agents/
        └── references/
```

## Current Skills

- `android-camera-porting-debug`

## Skill Design Rules

- Keep each skill under `skills/<skill-name>/`.
- Treat each skill as a reusable guide, not a one-off project note.
- Keep local runtime internals such as `.system/` out of this repository.
- Put project-specific details into references instead of hard-coding them into general skill prompts.

## Validate A Skill

Validate a copied or updated skill before committing:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  /path/to/skill
```

Example:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  /home/ray/source/ray-skills/skills/android-camera-porting-debug
```

## Suggested Workflow

1. Create or update a skill locally.
2. Validate it with `quick_validate.py`.
3. Copy or sync it into `skills/<skill-name>/`.
4. Review the repository diff.
5. Commit on a feature branch.
6. Push and merge after verification.

## Notes

- This repository stores skill source files, not the entire local Codex runtime.
- A skill may still reference local tools during authoring, but repository contents should remain portable.
- Keep README-level documentation concise; put deeper usage material inside the skill itself.
