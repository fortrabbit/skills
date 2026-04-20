# fortrabbit skills

Manage websites and web apps on [fortrabbit](https://www.fortrabbit.com) from your AI coding assistant — Claude Code, GitHub Copilot, OpenAI Codex, and Gemini CLI.

Version 0.1 — early preview. Uses SSH directly.

## What it does

- **setup** — guides you getting boarded
- **deploy** — trigger a deployment via deploy hook or remind you to push to your Git remote
- **ssh** — run remote commands (artisan, craft console, Composer)
- **db pull** — download the remote database to your local environment
- **db push** — upload your local database to the remote environment
- **content sync** — rsync CMS content up or down (Kirby, Statamic, WordPress, Craft CMS, Laravel)
- **help** — show all available commands

Supports: Laravel, Craft CMS, Kirby, Statamic, WordPress, and generic PHP.

## Install

### Claude Code

#### Option A — Plugin install (namespaced as `/fortrabbit:fortrabbit`)

Clone the repo, then start Claude Code with `--plugin-dir`. The skill is invoked as `/fortrabbit:fortrabbit` (plugin namespace + skill name).

**Per project:**

```shell
git clone https://github.com/fortrabbit/agent-plugin .claude/plugins/fortrabbit
claude --plugin-dir .claude/plugins/fortrabbit
```

**Globally:**

```shell
git clone https://github.com/fortrabbit/agent-plugin ~/.claude/plugins/fortrabbit
claude --plugin-dir ~/.claude/plugins/fortrabbit
```

> **Note:** `--plugin-dir` must be passed every Claude Code session. Add a shell alias to avoid repeating it:
> ```shell
> alias claude='claude --plugin-dir ~/.claude/plugins/fortrabbit'
> ```

Add to `.gitignore` if you don't want to commit the plugin:

```shell
echo ".claude/plugins/" >> .gitignore
```

#### Option B — Standalone install (short `/fortrabbit` name, persistent)

Copy the skill directly into `.claude/skills/`. This gives the short `/fortrabbit` command with no namespace, and no `--plugin-dir` flag needed on every session.

**Per project:**

```shell
git clone https://github.com/fortrabbit/agent-plugin /tmp/fortrabbit-plugin
mkdir -p .claude/skills/fortrabbit
cp -r /tmp/fortrabbit-plugin/skills/fortrabbit/. .claude/skills/fortrabbit/
```

**Globally:**

```shell
git clone https://github.com/fortrabbit/agent-plugin /tmp/fortrabbit-plugin
mkdir -p ~/.claude/skills/fortrabbit
cp -r /tmp/fortrabbit-plugin/skills/fortrabbit/. ~/.claude/skills/fortrabbit/
```

#### Option C — Marketplace (coming soon)

Once available in the Anthropic plugin marketplace, install with:

```shell
/plugin install fortrabbit
```

This gives `/fortrabbit:fortrabbit` persistently across sessions with no flags or manual copying. Submit URL: https://claude.ai/settings/plugins/submit

### GitHub Copilot

Copy `.github/instructions/fortrabbit.instructions.md` into your project's `.github/instructions/` folder:

```shell
mkdir -p .github/instructions
curl -o .github/instructions/fortrabbit.instructions.md \
  https://raw.githubusercontent.com/fortrabbit/agent-plugin/main/.github/instructions/fortrabbit.instructions.md
```

This uses Copilot's named instruction file system — it composes additively with any other instruction files you already have and does not require modifying an existing `copilot-instructions.md`.

### Gemini CLI

The `gemini-extension.json` and `GEMINI.md` files are picked up automatically when this repository is installed as a Gemini CLI extension.

### OpenAI Codex

**Globally** (available in all projects):

```shell
cat >> ~/.codex/AGENTS.md < <(curl -s \
  https://raw.githubusercontent.com/fortrabbit/agent-plugin/main/AGENTS.md)
```

**Per project** — append to your existing `AGENTS.md`:

```shell
cat >> AGENTS.md < <(curl -s \
  https://raw.githubusercontent.com/fortrabbit/agent-plugin/main/AGENTS.md)
```

Codex reads `AGENTS.md` from `~/.codex/` globally and from the project root, merging both.

## Requirements

- `ssh`, `rsync`, and `mysql`/`mysqldump` available in your local terminal
