# fortrabbit — Gemini CLI Instructions

This file configures Gemini CLI to assist with fortrabbit hosting tasks.

## What is fortrabbit?

[fortrabbit](https://www.fortrabbit.com) is a PHP cloud hosting platform. Apps deploy via Git push or a deploy hook URL. Remote commands run over SSH exec (no persistent shell). Supported stacks: Laravel, Craft CMS, Kirby, Statamic, WordPress, and generic PHP.

## Configuration lookup

When the user asks for a fortrabbit operation:

1. Read `.fortrabbit` from the project root. It uses a simple `key=value` format:
   ```
   app-env-id=en-xxxxxx
   region=eu-w1a
   ```
2. Fall back to `.env` → `FORTRABBIT_APP_ENV_ID`, `FORTRABBIT_REGION`.
3. If still not found, ask the user for `app-env-id` (format: `en-wjl0ai`) and `region` (default: `eu-w1a`).
4. For deploy hook operations, read `FORTRABBIT_DEPLOY_HOOK_SECRET` from `.env`. Construct the URL as:
   `https://api.fortrabbit.com/webhooks/environments/{app-env-id}/deploy/{secret}`

SSH host: `APP_ENV_ID@ssh.REGION.frbit.app`

## Operations

### `/fortrabbit deploy`

If `FORTRABBIT_DEPLOY_HOOK_SECRET` is set in `.env`, construct the URL from `app-env-id` and the secret:

```bash
curl -X POST \
  "https://api.fortrabbit.com/webhooks/environments/APP_ENV_ID/deploy/SECRET" \
  -H "User-Agent: fortrabbit"
```

A successful response returns JSON with a `publicId`. If no secret is configured, remind the user to push to their connected Git remote to trigger a deployment.

### `/fortrabbit ssh COMMAND`

```
ssh APP_ENV_ID@ssh.REGION.frbit.app COMMAND
```

### `/fortrabbit db pull`

Download the remote database and import locally. Warn that local data will be overwritten.

### `/fortrabbit db push`

Upload the local database to the remote. **Require explicit confirmation** before proceeding — this overwrites live data.

### `/fortrabbit content sync [up|down]`

Rsync CMS uploads/content between local and remote using the path for the detected framework.

### `/fortrabbit status`

Show the configured `app-env-id`, `region`, and detected project type.

### `/fortrabbit help`

List all available commands.

## Project type detection

Inspect `composer.json` and project root files:

| Signal | Type |
|--------|------|
| `artisan` file or `laravel/framework` dependency | Laravel |
| `craftcms/cms` dependency | Craft CMS |
| `statamic/cms` dependency | Statamic |
| `getkirby/cms` dependency | Kirby |
| `wp-config.php` present | WordPress |
| Other `composer.json` | Generic PHP |

## Safety rules

- Always show the exact command before running it.
- `db push` overwrites the live remote database — ask for explicit confirmation.
- `db pull` overwrites local data — warn the user.
- Never store passwords in files; use SSH tunnel method only.
- For destructive SSH commands (cache clear, queue flush, migrations): show and confirm first.
- If SSH fails, help the user verify their key at https://dash.fortrabbit.com/you/ssh-keys
