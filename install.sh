#!/usr/bin/env bash
# /bro installer — installs the bro skill into every AI agent CLI it finds.
# Usage:
#   ./install.sh          install into detected tools
#   ./install.sh --all    install into ALL supported tools (even if not detected)
set -euo pipefail

RAW="https://raw.githubusercontent.com/luchasarie/bro-skill/main"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || true)"

# Resolve SKILL.md — local copy first, otherwise download (supports curl | bash)
if [ -n "${SRC_DIR:-}" ] && [ -f "$SRC_DIR/SKILL.md" ]; then
  SKILL="$SRC_DIR/SKILL.md"
  CLEANUP=""
else
  SKILL="$(mktemp)"
  CLEANUP="$SKILL"
  echo "⬇  Downloading SKILL.md…"
  curl -fsSL "$RAW/SKILL.md" -o "$SKILL"
fi
trap '[ -n "$CLEANUP" ] && rm -f "$CLEANUP" || true' EXIT

# Body of the skill without YAML frontmatter (for slash-command wrappers)
BODY="$(awk 'BEGIN{n=0} /^---[ \t]*$/{n++; next} n>=2{print}' "$SKILL")"

ALL=0
[ "${1:-}" = "--all" ] && ALL=1

have() { command -v "$1" >/dev/null 2>&1; }
want() { # $1=name $2=dir $3=binary
  [ "$ALL" = 1 ] && return 0
  [ -d "$2" ] || have "$3"
}

INSTALLED=()

install_skill() { # $1 = skills root
  mkdir -p "$1/bro"
  # not cp: on the curl | bash path $SKILL is a mktemp file (0600) and that mode rides along
  install -m 644 "$SKILL" "$1/bro/SKILL.md"
}

write_cmd() { # $1 = target file
  mkdir -p "$(dirname "$1")"
  cat > "$1"
}

echo "🤙 Installing /bro…"
echo

# ── Hermes Agent ──────────────────────────────────────────────
if want hermes "$HOME/.hermes" hermes; then
  install_skill "$HOME/.hermes/skills"
  INSTALLED+=("Hermes Agent   → ~/.hermes/skills/bro/SKILL.md")
fi

# ── Claude Code ───────────────────────────────────────────────
if want claude "$HOME/.claude" claude; then
  install_skill "$HOME/.claude/skills"
  rm -f "$HOME/.claude/commands/bro.md"  # skills are exposed as /bro natively; drop the old duplicate wrapper
  INSTALLED+=("Claude Code    → ~/.claude/skills/bro/SKILL.md")
fi

# ── Cursor ────────────────────────────────────────────────────
# Always install into ~/.cursor/skills (mkdir -p). Cursor *also* reads
# ~/.codex/skills and ~/.claude/skills, but those dirs only exist if you
# already use Codex/Claude — Cursor-only users will not have them.
if want cursor "$HOME/.cursor" cursor; then
  install_skill "$HOME/.cursor/skills"
  INSTALLED+=("Cursor         → ~/.cursor/skills/bro/SKILL.md")
fi

# ── OpenAI Codex ──────────────────────────────────────────────
if want codex "$HOME/.codex" codex; then
  install_skill "$HOME/.codex/skills"
  printf '%s\n' "$BODY" | write_cmd "$HOME/.codex/prompts/bro.md"
  INSTALLED+=("Codex CLI      → ~/.codex/skills/bro/ + /bro prompt")
fi

# ── opencode ──────────────────────────────────────────────────
OC_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
if want opencode "$OC_CFG" opencode; then
  install_skill "$OC_CFG/skills"
  # honor whichever command dir convention already exists
  if [ -d "$OC_CFG/commands" ]; then OC_CMDS="$OC_CFG/commands"; else OC_CMDS="$OC_CFG/command"; fi
  printf -- '---\ndescription: Re-explain the last answer in plain language ("bro what" mode)\n---\n\n%s\n' "$BODY" \
    | write_cmd "$OC_CMDS/bro.md"
  INSTALLED+=("opencode       → $OC_CFG/skills/bro/ + /bro command")
fi

echo
if [ "${#INSTALLED[@]}" = 0 ]; then
  echo "⚠  No supported tools detected. Run './install.sh --all' to install everywhere anyway."
  exit 1
fi

printf '✅ %s\n' "${INSTALLED[@]}"
echo
echo "Done. Restart your agent (or start a new session) and type /bro after any dense reply."
