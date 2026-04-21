#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$SCRIPT_DIR" = "$HOME/.claude/skills/fortrabbit" ] || [ "$SCRIPT_DIR" = "$HOME/.agents/skills/fortrabbit" ]; then
  CLAUDE_DIR="$HOME/.claude/skills/fortrabbit"
  CODEX_DIR="$HOME/.agents/skills/fortrabbit"
  SCOPE="global"
  COPILOT_FILE=""
else
  PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
  CLAUDE_DIR="$PROJECT_ROOT/.claude/skills/fortrabbit"
  CODEX_DIR="$PROJECT_ROOT/.agents/skills/fortrabbit"
  COPILOT_FILE="$PROJECT_ROOT/.github/instructions/fortrabbit.instructions.md"
  SCOPE="project"
fi

echo "This will remove the fortrabbit skills ($SCOPE install):"
[ -d "$CLAUDE_DIR" ] && echo "  $CLAUDE_DIR"
[ -d "$CODEX_DIR" ]  && echo "  $CODEX_DIR"
[ -n "$COPILOT_FILE" ] && [ -f "$COPILOT_FILE" ] && echo "  $COPILOT_FILE"
echo ""
printf "Continue? [y/N] "
read -r CONFIRM
case "$CONFIRM" in
  [yY]) ;;
  *) echo "Aborted."; exit 0 ;;
esac

[ -d "$CLAUDE_DIR" ] && rm -rf "$CLAUDE_DIR" && echo "Removed $CLAUDE_DIR"
[ -d "$CODEX_DIR" ]  && rm -rf "$CODEX_DIR"  && echo "Removed $CODEX_DIR"
[ -n "$COPILOT_FILE" ] && [ -f "$COPILOT_FILE" ] && rm "$COPILOT_FILE" && echo "Removed $COPILOT_FILE"

echo ""
echo "fortrabbit skills uninstalled."
