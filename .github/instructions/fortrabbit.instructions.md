---
applyTo: "**"
---

# fortrabbit — GitHub Copilot Instructions

When helping the user with fortrabbit-related tasks, follow the guidance below.

## What fortrabbit is

[fortrabbit](https://www.fortrabbit.com) is cloud hosting platform for websites and web apps. Apps are deployed via Git push or a deploy hook URL. Remote commands run over SSH exec (no persistent session). Supported PHP frameworks: Laravel, Craft CMS, Kirby, Statamic, WordPress, and generic PHP.

## Configuration lookup

Read config in this order (`.fortrabbit` is the source of truth):

1. Read `.fortrabbit` from the project root first. It uses a simple `key=value` format:
   ```
   app-env-id=en-xxxxxx
   region=eu-w1a
   ```
2. If any value is missing from `.fortrabbit`, supplement from `.env` variables `FORTRABBIT_APP_ENV_ID` and `FORTRABBIT_REGION`.
3. If still missing, ask the user for their app environment ID (format: `en-wjl0ai`) and region (default: `eu-w1a`).
4. If both files define the same key with different values, do not merge silently — ask: "I found two different values for [key]: `[value-a]` (`.fortrabbit`) and `[value-b]` (`.env`). Which is correct?"
5. For deploy hook operations, read `FORTRABBIT_DEPLOY_HOOK_SECRET` from `.env`. Construct the URL as:
   `https://api.fortrabbit.com/webhooks/environments/{app-env-id}/deploy/{secret}`

SSH host pattern: `APP_ENV_ID@ssh.REGION.frbit.app`

## Available operations

| Command      | What it does                                                                                                                                    |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| deploy       | Read `FORTRABBIT_DEPLOY_HOOK_SECRET` from `.env`, construct URL, POST with `User-Agent: fortrabbit`; or remind user to push to their Git remote |
| ssh          | Run a remote command via SSH exec                                                                                                               |
| db pull      | Download remote MySQL database to local                                                                                                         |
| db push      | Upload local MySQL database to remote                                                                                                           |
| content sync | Rsync CMS uploads/content up or down                                                                                                            |
| status       | Show configured environment and detected project type                                                                                           |

## Project type detection

Check signals in this exact order (first match wins):

```
1. wp-config.php exists OR wp-content/ directory exists → WordPress
2. composer.json contains "craftcms/cms" OR bin/craft exists → Craft CMS
3. composer.json contains "statamic/cms" → Statamic
4. composer.json contains "getkirby/cms" OR site/plugins/ exists → Kirby
5. composer.json contains "laravel/framework" OR artisan file exists at root → Laravel
6. composer.json exists (none of the above) → Generic PHP
7. Nothing found → Ask: "What CMS or framework are you using? (WordPress, Craft CMS, Kirby, Statamic, Laravel, other PHP)"
```

## Safety rules

- Always show the exact SSH command before running it.
- `db push` overwrites the remote database — require explicit user confirmation.
- `db pull` overwrites the local database — warn the user first.
- Never run `DROP DATABASE`, `DROP TABLE`, or `TRUNCATE` without showing the statement and requiring explicit confirmation.
- Never store database passwords in files; use SSH tunnel method only.
- If SSH connection fails, classify the error before acting:
  - `Permission denied (publickey)` → Tell the user their SSH key may not be registered. Direct them to https://dash.fortrabbit.com/you/ssh-keys
  - `Connection timed out` / `Connection refused` / `Network is unreachable` → Tell the user to check (1) internet connection, (2) port 22 not blocked by firewall/VPN, (3) correct region
  - Any other error → Show the full error text and ask what they see

## Response format

1. One sentence stating what you are about to do.
2. The exact command(s) that will run.
3. Confirmation prompt for any destructive operation.
4. Outcome report.
5. Suggested next step.
