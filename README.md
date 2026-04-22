# fortrabbit agentic skills

Manage websites and web apps on [fortrabbit](https://www.fortrabbit.com) from your AI coding assistant — Claude Code, OpenAI Codex, and GitHub Copilot.

Version 0.2 — early preview.

## What it does

- **start** — boarding q&a
- **connect** — configure your computer, connect to fortrabbit
- **deploy** — trigger a deployment via deploy hook or push to your Git remote
- **sync** — rsync all content up or down
- **content sync** — rsync only CMS content up or down
- **ssh** — run remote commands (artisan, craft console, Composer)
- **db pull** — download the remote database to your local environment
- **db push** — upload your local database to the remote environment
- **help** — show all available commands

Supports: Laravel, Craft CMS, Kirby, Statamic, WordPress, and generic PHP.

## Install

Run this anywhere to install globally for your user — available across all your projects:

```shell
curl -fsSL https://raw.githubusercontent.com/fortrabbit/skills/main/install.sh | sh
```

The script detects which tools are installed on your machine and only installs into existing config directories (`~/.claude` for Claude Code, `~/.agents` for OpenAI Codex). It exits with an error if neither is found.

### Per-project install

To install into a specific project instead, run this in the project root:

```shell
curl -fsSL https://raw.githubusercontent.com/fortrabbit/skills/main/install.sh | sh -s -- --project
```

This also installs **GitHub Copilot** instructions (repo-scoped). Note that a per-project install adds a `.claude/` directory to your project folder — this means `composer create-project` will refuse to run there since it requires an empty directory. Prefer the global install when starting a new project from scratch.

### What gets installed

| Target         | Per-project                                       | Global                         |
| -------------- | ------------------------------------------------- | ------------------------------ |
| Claude Code    | `.claude/skills/fortrabbit/`                      | `~/.claude/skills/fortrabbit/` |
| OpenAI Codex   | `.agents/skills/fortrabbit/`                      | `~/.agents/skills/fortrabbit/` |
| GitHub Copilot | `.github/instructions/fortrabbit.instructions.md` | — (repo-scoped)                |

## Uninstall

Run `/fortrabbit uninstall` inside your agent, or run the uninstall script directly:

```shell
# If globally install
~/.claude/skills/fortrabbit/uninstall.sh

# Per-project install (from project root)
.claude/skills/fortrabbit/uninstall.sh
```

The script lists what will be removed and asks for confirmation before deleting anything.

## Requirements

- `ssh`, `rsync` available in your local terminal

## Disclaimer

These skills are provided as-is, without warranty of any kind. Use at your own risk. Always review the commands your agent proposes before confirming — especially destructive operations like database push/pull.
