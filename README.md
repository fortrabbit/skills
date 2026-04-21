# fortrabbit skills

Manage websites and web apps on [fortrabbit](https://www.fortrabbit.com) from your AI coding assistant — Claude Code, OpenAI Codex, and GitHub Copilot.

Version 0.1 — early preview.

## What it does

- **start** — boarding q&a
- **setup** — configure your computer, setup up
- **deploy** — trigger a deployment via deploy hook or push to your Git remote
- **sync** — rsync all content up or down
- **content sync** — rsync only CMS content up or down
- **ssh** — run remote commands (artisan, craft console, Composer)
- **db pull** — download the remote database to your local environment
- **db push** — upload your local database to the remote environment
- **help** — show all available commands

Supports: Laravel, Craft CMS, Kirby, Statamic, WordPress, and generic PHP.

## Install

Run this in your project root:

```shell
curl -fsSL https://raw.githubusercontent.com/fortrabbit/skills/main/install.sh | sh
```

Or to install globally (available in all projects):

```shell
curl -fsSL https://raw.githubusercontent.com/fortrabbit/skills/main/install.sh | sh -s -- --global
```

The script installs the skill for **Claude Code**, **OpenAI Codex**, and **GitHub Copilot** in one go.

### What gets installed

| Target | Per-project | Global |
|--------|-------------|--------|
| Claude Code | `.claude/skills/fortrabbit/` | `~/.claude/skills/fortrabbit/` |
| OpenAI Codex | `.agents/skills/fortrabbit/` | `~/.agents/skills/fortrabbit/` |
| GitHub Copilot | `.github/instructions/fortrabbit.instructions.md` | — (repo-scoped) |

## Requirements

- `ssh`, `rsync` available in your local terminal
