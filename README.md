# fortrabbit skills

Manage websites and web apps on [fortrabbit](https://www.fortrabbit.com) from your AI coding assistant — Claude Code, GitHub Copilot, OpenAI Codex, and Gemini CLI.

Version 0.1 — early preview. Uses SSH directly.

## What it does

- **deploy** — trigger a deployment via deploy hook or remind you to push to your Git remote
- **ssh** — run remote commands (artisan, craft console, Composer)
- **db pull** — download the remote database to your local environment
- **db push** — upload your local database to the remote environment
- **content sync** — rsync CMS content up or down (Kirby, Statamic, WordPress, Craft CMS, Laravel)
- **help** — show all available commands

Supports: Laravel, Craft CMS (4, 5), Kirby, Statamic, WordPress, and generic PHP.

## Install

### Claude Code

```shell
# Planned via marketplace
/plugin install fortrabbit
```

Or manually — **globally** (available in all projects):

```shell
git clone https://github.com/fortrabbit/agent-plugin ~/.claude/plugins/fortrabbit
```

Then start Claude Code with the `--plugin-dir` flag to activate it:

```shell
claude --plugin-dir ~/.claude/plugins/fortrabbit
```

Or **per project** (checked into your project repo):

```shell
git clone https://github.com/fortrabbit/agent-plugin .claude/plugins/fortrabbit
```

Then start Claude Code from your project root with:

```shell
claude --plugin-dir .claude/plugins/fortrabbit
```

> **Note:** The `git clone` alone does not register the plugin — Claude Code does not auto-discover plugins from the plugins directory. The `--plugin-dir` flag is required until marketplace-based installation (`/plugin install fortrabbit`) is available.

Add to `.gitignore` if you don't want to commit it:

```shell
echo ".claude/plugins/" >> .gitignore
```

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

## Configuration

Create a `.fortrabbit` file in your project root — this file contains no secrets and can be committed:

```text
app-env-id=en-xxxxxx
region=eu-w1a
```

If you use a deploy hook, store only the secret token in `.env` (which should already be gitignored):

```text
FORTRABBIT_DEPLOY_HOOK_SECRET=your-secret-token
```

The deploy hook URL is constructed automatically from `app-env-id` and the secret.

On first use without a config file, the assistant will ask for your app environment ID and region. Both are shown in the [fortrabbit dashboard](https://dash.fortrabbit.com).

## Requirements

- An SSH key registered with the [fortrabbit dashboard](https://dash.fortrabbit.com/you/ssh-keys)
- `ssh`, `rsync`, and `mysql`/`mysqldump` available in your local terminal
