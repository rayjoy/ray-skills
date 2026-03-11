# ray-skills

Personal Codex and agent skills maintained in a standalone GitHub repository.

## Repository Layout

```text
ray-skills/
└── skills/
    └── <skill-name>/
        ├── SKILL.md
        ├── agents/
        └── references/
```

## Current Skills

- `android-camera-porting-debug`

## Purpose

This repository stores reusable personal skills outside the local Codex runtime directory so they can be versioned, reviewed, and shared across machines.

## Notes

- Keep each skill in `skills/<skill-name>/`.
- Do not copy local system skills such as `.system/` into this repository.
- Validate a skill with:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py <path-to-skill>
```
