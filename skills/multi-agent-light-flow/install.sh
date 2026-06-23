#!/usr/bin/env bash
# Install multi-agent-light-flow for Claude Code (symlink) and Codex (global AGENTS.md pointer).
# The repository stays the single source of truth. Idempotent: safe to re-run.
set -euo pipefail

NAME="multi-agent-light-flow"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # canonical skill dir in the repo
SKILL_MD="$HERE/SKILL.md"

CLAUDE_LINK="$HOME/.claude/skills/$NAME"
AGENTS_HUB="$HOME/.agents/skills/$NAME"
CODEX_AGENTS="$HOME/.codex/AGENTS.md"

BEGIN_MARKER="<!-- BEGIN multi-agent-light-flow pointer -->"
END_MARKER="<!-- END multi-agent-light-flow pointer -->"

log() { printf '[install] %s\n' "$*"; }

mkdir -p "$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.codex"

make_link() {
  local target="$1" link="$2"
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    log "SKIP $link: a real file/dir already exists there. Remove it manually and re-run."
    return 0
  fi
  ln -sfn "$target" "$link"
  log "linked $link -> $target"
}

# Claude Code: two-level symlink, repo = source.
make_link "$HERE" "$AGENTS_HUB"
make_link "../../.agents/skills/$NAME" "$CLAUDE_LINK"

# Codex: global AGENTS.md pointer block (idempotent via markers).
POINTER_BODY="$BEGIN_MARKER
## Multi-Agent Light Flow

When a task involves multiple agents, separated execution and review,
cross-session or cross-tool handoff, approval checkpoints, evidence-gated
work, or explicit Main/Work/Review/User coordination, read and follow the
rules in:

$SKILL_MD

That file is the single source of truth for the flow, role locks, read-only
Review, Conditional pass, push/closeout boundaries, and non-self-invalidating
evidence.
$END_MARKER"

if [ ! -f "$CODEX_AGENTS" ]; then
  printf '%s\n' "$POINTER_BODY" > "$CODEX_AGENTS"
  log "created $CODEX_AGENTS"
elif grep -qF "$BEGIN_MARKER" "$CODEX_AGENTS"; then
  sed -i -e "/$BEGIN_MARKER/,/$END_MARKER/d" "$CODEX_AGENTS"
  printf '\n%s\n' "$POINTER_BODY" >> "$CODEX_AGENTS"
  log "updated pointer block in $CODEX_AGENTS"
else
  printf '\n%s\n' "$POINTER_BODY" >> "$CODEX_AGENTS"
  log "appended pointer block to $CODEX_AGENTS"
fi

# Optional validation.
VALIDATOR="$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py"
if [ -f "$VALIDATOR" ]; then
  log "running validator..."
  if python3 "$VALIDATOR" "$HERE"; then
    log "validation: PASS"
  else
    log "validation: NON-ZERO (see above)"
  fi
else
  log "validator not found at $VALIDATOR — skipped"
fi

log "done."
