#!/bin/sh
set -e

REPO_URL="https://github.com/fortrabbit/skills/archive/refs/heads/main.tar.gz"
GLOBAL=false

for arg in "$@"; do
  case $arg in
    --global|-g) GLOBAL=true ;;
  esac
done

if $GLOBAL; then
  CLAUDE_DIR="$HOME/.claude/skills/fortrabbit"
  CODEX_DIR="$HOME/.agents/skills/fortrabbit"
  SCOPE="global"
else
  CLAUDE_DIR=".claude/skills/fortrabbit"
  CODEX_DIR=".agents/skills/fortrabbit"
  SCOPE="project"
fi

echo "Installing fortrabbit agent skills ($SCOPE)..."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -fsSL "$REPO_URL" | tar xz -C "$TMP" --strip-components=1

# Claude Code
mkdir -p "$CLAUDE_DIR"
cp -r "$TMP/skills/fortrabbit/." "$CLAUDE_DIR/"
echo "  Claude Code  →  $CLAUDE_DIR"

# OpenAI Codex
mkdir -p "$CODEX_DIR"
cp -r "$TMP/skills/fortrabbit/." "$CODEX_DIR/"
echo "  Codex        →  $CODEX_DIR"

# GitHub Copilot (per-project only — instructions are repo-scoped)
if ! $GLOBAL; then
  mkdir -p ".github/instructions"
  cp "$TMP/.github/instructions/fortrabbit.instructions.md" ".github/instructions/"
  echo "  Copilot      →  .github/instructions/fortrabbit.instructions.md"
fi

echo ""
echo "Done. Use /fortrabbit in Claude Code to get started."
