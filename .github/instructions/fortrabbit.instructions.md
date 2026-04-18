---
applyTo: "**"
---

# fortrabbit — GitHub Copilot Instructions

When helping the user with fortrabbit-related tasks, follow the guidance below.

## What fortrabbit is

[fortrabbit](https://www.fortrabbit.com) is cloud hosting platform for websites and web apps. Apps are deployed via Git push or a deploy hook URL. Remote commands run over SSH exec (no persistent session). Supported PHP frameworks: Laravel, Craft CMS, Kirby, Statamic, WordPress, and generic PHP.

## Configuration lookup

1. Read `.fortrabbit` from the project root. It uses a simple `key=value` format:
   ```
   app-env-id=en-xxxxxx
   region=eu-w1a
   ```
2. Fall back to `.env` variables `FORTRABBIT_APP_ENV_ID` and `FORTRABBIT_REGION`.
3. If neither exists, ask the user for their app environment ID (format: `en-wjl0ai`) and region (default: `eu-w1a`).
4. For deploy hook operations, read `FORTRABBIT_DEPLOY_HOOK_SECRET` from `.env`. Construct the URL as:
   `https://api.fortrabbit.com/webhooks/environments/{app-env-id}/deploy/{secret}`

SSH host pattern: `APP_ENV_ID@ssh.REGION.frbit.app`

## Available operations

| Command | What it does |
|---------|-------------|
| deploy | Read `FORTRABBIT_DEPLOY_HOOK_SECRET` from `.env`, construct URL, POST with `User-Agent: fortrabbit`; or remind user to push to their Git remote |
| ssh | Run a remote command via SSH exec |
| db pull | Download remote MySQL database to local |
| db push | Upload local MySQL database to remote |
| content sync | Rsync CMS uploads/content up or down |
| status | Show configured environment and detected project type |

## Project type detection

| Signal | Type |
|--------|------|
| `artisan` file or `laravel/framework` in composer.json | Laravel |
| `craftcms/cms` in composer.json | Craft CMS |
| `statamic/cms` in composer.json | Statamic |
| `getkirby/cms` in composer.json | Kirby |
| `wp-config.php` present | WordPress |
| Other composer.json | Generic PHP |

## Safety rules

- Always show the exact SSH command before running it.
- `db push` overwrites the remote database — require explicit user confirmation.
- `db pull` overwrites the local database — warn the user first.
- Never run `DROP DATABASE`, `DROP TABLE`, or `TRUNCATE` without showing the statement and requiring explicit confirmation.
- Never store database passwords in files; use SSH tunnel method only.
- If SSH connection fails, help the user verify their SSH key is registered at https://dash.fortrabbit.com/you/ssh-keys

## Response format

1. One sentence stating what you are about to do.
2. The exact command(s) that will run.
3. Confirmation prompt for any destructive operation.
4. Outcome report.
5. Suggested next step.
