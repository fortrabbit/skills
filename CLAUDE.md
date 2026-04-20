# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**fortrabbit/agent-plugin** is a multi-platform AI assistant plugin for managing PHP web applications hosted on fortrabbit. It ships instructional content consumed by Claude Code, GitHub Copilot, Google Gemini CLI, and OpenAI Codex — there is no build step, no compiled code, and no tests.

## Architecture

The project provides the same operational guidance in four platform-specific formats:

| File | Platform |
|------|----------|
| `SKILL.md` | Claude Code (primary entry point, YAML frontmatter + Markdown) |
| `GEMINI.md` + `gemini-extension.json` | Google Gemini CLI |
| `AGENTS.md` | OpenAI Codex |
| `.github/instructions/fortrabbit.instructions.md` | GitHub Copilot |
| `.claude-plugin/plugin.json` | Claude Code plugin manifest |

`SKILL.md` is the canonical source. When updating operational guidance, changes must be propagated consistently to all four platform formats.

### Skill reference files

`skills/fortrabbit/references/` contains operation guides loaded contextually by `SKILL.md`:

- `setup.md` — SSH key setup and connection troubleshooting
- `deploy.md` — Git push and deploy hook workflows
- `ssh-exec.md` — Remote command syntax per framework
- `database.md` — SSH tunnel setup and DB pull/push procedures
- `content-sync.md` — Per-framework rsync paths and examples

## Key Conventions

**Config lookup chain** (in order):
1. `.fortrabbit` file (`app-env-id`, `region`) — committed, no secrets
2. `.env` (`FORTRABBIT_APP_ENV_ID`, `FORTRABBIT_REGION`, `FORTRABBIT_DEPLOY_HOOK_SECRET`)
3. Prompt the user if neither exists

**Project type detection** (file/dependency signals):
- `artisan` file or `laravel/framework` in composer.json → Laravel
- `craftcms/cms` in composer.json → Craft CMS
- `statamic/cms` → Statamic
- `getkirby/cms` → Kirby
- `wp-config.php` → WordPress
- Other `composer.json` → Generic PHP

**SSH host pattern:** `APP_ENV_ID@ssh.REGION.frbit.app`

**Safety rules enforced in all formats:**
- Always print the full command before executing
- Require explicit user confirmation for destructive ops (db push/pull, DROP statements)
- Database access is only via SSH tunnel — no direct remote connections
- Never store passwords in files
- Load `setup.md` automatically on SSH failures

## Supported Frameworks

Laravel, Craft CMS, Statamic, Kirby, WordPress, Generic PHP. Every reference file must include a section for each of the six stacks.
