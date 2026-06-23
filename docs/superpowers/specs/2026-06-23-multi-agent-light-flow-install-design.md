# Multi-Agent Light Flow Install Design (Claude Code + Codex)

## Context

The `multi-agent-light-flow` skill is version-controlled in this repository at `skills/multi-agent-light-flow/`, but it is currently **installed nowhere**. Investigation on 2026-06-23 found:

- The skill exists only as repository source. It is not present in any live runtime config.
- `~/.copilot/skills/` is empty. The earlier hardening task's stage-9 record claiming an install there is stale/reverted and is no longer relevant. The user now targets **Codex** and **Claude Code**, not Copilot.
- **Claude Code** uses a native skill system. The established install pattern is a real directory under `~/.agents/skills/<name>` plus a symlink `~/.claude/skills/<name> -> ../../.agents/skills/<name>`. This skill is absent from both.
- **Codex** (`codex-cli 0.142.0`) has **no native skill or prompt discovery**. The `plugin` subcommand manages MCP-backed integrations only (Slack, Linear, etc.), which is the wrong fit for static guidance. `~/.codex/AGENTS.md` is **missing**; Codex reads a global `AGENTS.md` every session, which is the only realistic bridge for this kind of content.
- The repository `.claude/settings.local.json` already permits `git *`, `codex --version`, and `codex --help`.

The user wants the skill to support **their personal, user-global** Codex and Claude Code setups, with the repository remaining the single source of truth and the install reproducible across machines.

## Goals

- Make `multi-agent-light-flow` available to Claude Code via its native skill mechanism, user-global.
- Make the same flow rules reachable by Codex via its global `AGENTS.md`, user-global.
- Keep the repository as the single source of truth — edits in the repo flow live into both tools with no copy drift.
- Make the install reproducible: an idempotent script committed to the repo recreates the full install from a clean checkout.
- Keep the change scoped to installation wiring. Do not alter skill content.

## Non-Goals

- Do not change `SKILL.md` or any reference template content.
- Do not bundle the deferred round-two optimizations (the hardening task's stage 10: sync document location, hardcoded Chinese doc names, role-merge rules). Those are a separate task.
- Do not touch the historical hardening planning documents under `.planning/`.
- Do not reintroduce or repair the abandoned `~/.copilot/` workspace install.
- Do not set up per-project `AGENTS.md` files; the target is user-global only.
- Do not push or publish without explicit user approval.

## Decisions (locked during brainstorming)

1. **Codex integration = global `~/.codex/AGENTS.md` pointer.** A single marked block states the trigger condition and directs Codex to read the canonical `SKILL.md`. One-line per-session overhead; full rules loaded on demand; single source.
2. **Claude install = two-level symlink through `~/.agents/skills/`**, repository as ultimate target. Matches the existing peer-skill convention (`caveman`, etc.) while keeping the repo as the only editable copy.
3. **Scope = live install now + a reproducible `install.sh` committed to the repo + a short README section.** No skill-content changes.

## Proposed Changes

### 1. Claude Code wiring (two-level symlink, repo = source)

- `~/.agents/skills/multi-agent-light-flow` -> repository directory `skills/multi-agent-light-flow`.
- `~/.claude/skills/multi-agent-light-flow` -> `../../.agents/skills/multi-agent-light-flow`.

Both links are created with `ln -sfn` so the script is idempotent and will not descend into or damage a real target directory. Because the first link points at the repository directory, any edit committed to the repo is immediately visible to Claude Code. No copy, no drift.

### 2. Codex wiring (global `~/.codex/AGENTS.md` pointer)

Create `~/.codex/AGENTS.md` (it does not exist today). Insert one marked block:

```markdown
<!-- BEGIN multi-agent-light-flow pointer -->
## Multi-Agent Light Flow

When a task involves multiple agents, separated execution and review,
cross-session or cross-tool handoff, approval checkpoints, evidence-gated
work, or explicit Main/Work/Review/User coordination, read and follow the
rules in:

<ABS_REPO>/skills/multi-agent-light-flow/SKILL.md

That file is the single source of truth for the flow, role locks, read-only
Review, Conditional pass, push/closeout boundaries, and non-self-invalidating
evidence.
<!-- END multi-agent-light-flow pointer -->
```

`<ABS_REPO>` is the absolute path resolved by `install.sh` at install time (for this machine, `/home/ray/source/ray-skills`), so Codex receives an unambiguous path it can read directly.

The `BEGIN`/`END` markers make the insertion idempotent: on re-run, `install.sh` replaces any existing block between the markers instead of duplicating it. If a user-created `AGENTS.md` already exists outside the markers, it is preserved untouched and the block is appended.

### 3. `skills/multi-agent-light-flow/install.sh`

A small, dependency-free Bash script committed alongside the skill so it travels with the repository. Responsibilities:

- `set -euo pipefail`.
- Resolve its own real directory via `$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)` so it works whether invoked from the repo or through a symlink; this is the canonical skill path and the basis for the absolute `SKILL.md` path written into the Codex block.
- Ensure `~/.claude/skills`, `~/.agents/skills`, and `~/.codex` exist (`mkdir -p`).
- Before creating each link, check whether a real (non-symlink) file or directory already exists at the target path (`[ -e "$link" ] && [ ! -L "$link" ]`). If so, print a message and abort that link rather than removing or overwriting it. Otherwise create the link with `ln -sfn` (idempotent replacement of existing symlinks).
- Write/replace the `AGENTS.md` pointer block idempotently using the markers.
- If `~/.codex/skills/.system/skill-creator/scripts/quick_validate.py` exists, run it against the skill directory and report the result; otherwise skip with a note.
- Print a concise summary of every action taken (links created/replaced, AGENTS.md created/updated, validation result).

The script performs only user-global filesystem wiring under `$HOME`. It does not modify the repository and does not touch other skills.

### 4. README additions

Add a short **Install** section to both `README.md` and `README.zh-CN.md`:

```bash
bash skills/multi-agent-light-flow/install.sh
```

with one line noting it wires Claude Code (symlink) and Codex (global `AGENTS.md` pointer), repository as single source.

## Verification

After running the script:

- `ls -l ~/.claude/skills/multi-agent-light-flow` resolves (via the hub link) to the repository directory.
- `readlink -f ~/.claude/skills/multi-agent-light-flow/SKILL.md` points inside the repository.
- `ls -l ~/.agents/skills/multi-agent-light-flow` points to the repository directory.
- `~/.codex/AGENTS.md` contains exactly one `BEGIN/END multi-agent-light-flow pointer` block referencing the absolute `SKILL.md` path.
- Re-running `install.sh` produces no duplicate block and leaves both links correct.
- `quick_validate.py` (if present) passes against the skill directory.

## Git

- Work on a feature branch (the repository is currently on `main`).
- Commit only the new `install.sh` and the README updates. The home-directory symlinks and `~/.codex/AGENTS.md` are outside the repository and are not committed.
- Do not push without explicit user approval.

## Risks and Notes

- **Symlink chain fragility:** `~/.claude/skills/<name>` points to `~/.agents/skills/<name>`, which points to the repo. This is a two-hop chain and deviates from the single-hop links used by some peers, but it matches the dominant existing convention and keeps a single editable copy in the repo. `readlink -f` verification confirms resolution after install.
- **Machine-specific absolute path in AGENTS.md:** The pointer embeds an absolute repo path. This is correct for the user's machine and is regenerated by `install.sh` on each run, so re-running on another machine rewrites the correct path.
- **Idempotency vs. existing user files:** The script never overwrites a user-authored `AGENTS.md`; it only manages content between its own markers. Existing symlinks are replaced with `ln -sfn`; if a real (non-symlink) directory already exists at a link target, the script will note it and refuse to `rm -rf` blindly, requiring manual resolution, to avoid destroying a local copy.
