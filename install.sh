#!/bin/sh
set -e

REPO_URL="https://github.com/fortrabbit/agent-skills/archive/refs/heads/main.tar.gz"
LOCAL=false

for arg in "$@"; do
  case $arg in
    --project|-p) LOCAL=true ;;
  esac
done

HAS_CLAUDE=false
HAS_CODEX=false

if $LOCAL; then
  CLAUDE_DIR=".claude/skills/fortrabbit"
  CODEX_DIR=".agents/skills/fortrabbit"
  SCOPE="project"
else
  CLAUDE_DIR="$HOME/.claude/skills/fortrabbit"
  CODEX_DIR="$HOME/.agents/skills/fortrabbit"
  SCOPE="global"

  # For global installs, only target tools that are actually installed
  [ -d "$HOME/.claude" ] && HAS_CLAUDE=true
  [ -d "$HOME/.agents" ] && HAS_CODEX=true

  if ! $HAS_CLAUDE && ! $HAS_CODEX; then
    echo "Error: Neither Claude Code (~/.claude) nor OpenAI Codex (~/.agents) appears to be installed."
    echo "Install one of those tools first, or use --local to install per-project."
    exit 1
  fi
fi

echo "Installing fortrabbit agent-skills ($SCOPE)..."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -fsSL "$REPO_URL" | tar xz -C "$TMP" --strip-components=1

install_skill() {
  DIR="$1"
  mkdir -p "$DIR"
  cp -r "$TMP/skills/fortrabbit/." "$DIR/"
  cp "$TMP/VERSION" "$DIR/.version"
  cp "$TMP/update.sh" "$DIR/update.sh"
  cp "$TMP/uninstall.sh" "$DIR/uninstall.sh"
  chmod +x "$DIR/update.sh" "$DIR/uninstall.sh"
  date +%s > "$DIR/.last-update-check"
}

# Claude Code
if $LOCAL || $HAS_CLAUDE; then
  install_skill "$CLAUDE_DIR"
  echo "  Claude Code  →  $CLAUDE_DIR"
fi

# OpenAI Codex
if $LOCAL || $HAS_CODEX; then
  install_skill "$CODEX_DIR"
  echo "  Codex        →  $CODEX_DIR"
fi

# GitHub Copilot (per-project only — instructions are repo-scoped)
if $LOCAL; then
  mkdir -p ".github/instructions"
  cp "$TMP/.github/instructions/fortrabbit.instructions.md" ".github/instructions/"
  echo "  Copilot      →  .github/instructions/fortrabbit.instructions.md"
fi

echo ""
echo "Done. Use /fortrabbit with your agent to get started."
