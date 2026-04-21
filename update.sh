#!/bin/sh
set -e

VERSION_URL="https://raw.githubusercontent.com/fortrabbit/skills/main/VERSION"
INSTALL_URL="https://raw.githubusercontent.com/fortrabbit/skills/main/install.sh"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION_FILE="$SCRIPT_DIR/.version"

LOCAL=$(cat "$VERSION_FILE" 2>/dev/null || echo "unknown")
REMOTE=$(curl -fsSL "$VERSION_URL" | tr -d '[:space:]')

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "fortrabbit skills are up to date (v$LOCAL)."
  exit 0
fi

echo "Update available: v$LOCAL → v$REMOTE"

if [ "$SCRIPT_DIR" = "$HOME/.claude/skills/fortrabbit" ] || [ "$SCRIPT_DIR" = "$HOME/.agents/skills/fortrabbit" ]; then
  FLAG="--global"
else
  FLAG=""
fi

curl -fsSL "$INSTALL_URL" | sh -s -- $FLAG
