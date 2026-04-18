# fortrabbit — Agent Instructions

This file configures AI coding agents (OpenAI Codex CLI and compatible tools) to assist with fortrabbit hosting tasks.

## Overview

[fortrabbit](https://www.fortrabbit.com) is a PHP cloud hosting platform. Apps deploy via Git push or a deploy hook URL. Remote commands run over SSH exec (no interactive shell). Supported stacks: Laravel, Craft CMS, Kirby, Statamic, WordPress, generic PHP.

## Setup

Before running any fortrabbit operation:

1. Look for `.fortrabbit` in the project root. It uses a simple `key=value` format:
   ```
   app-env-id=en-xxxxxx
   region=eu-w1a
   ```
2. If not found, check `.env` for `FORTRABBIT_APP_ENV_ID` and `FORTRABBIT_REGION`.
3. If still not found, ask:
   - "What is your fortrabbit app environment ID?" (format: `en-wjl0ai`)
   - "What region is your app in?" (default: `eu-w1a`)
4. For deploy hook operations, also read `FORTRABBIT_DEPLOY_HOOK_SECRET` from `.env`. Construct the URL as:
   `https://api.fortrabbit.com/webhooks/environments/{app-env-id}/deploy/{secret}`

SSH host: `APP_ENV_ID@ssh.REGION.frbit.app`

## Capabilities

### Deploy

Trigger a deployment. Check for `FORTRABBIT_DEPLOY_HOOK_SECRET` in `.env`. If present, construct the URL from `app-env-id` and the secret, then POST to it:

```bash
curl -X POST \
  "https://api.fortrabbit.com/webhooks/environments/APP_ENV_ID/deploy/SECRET" \
  -H "User-Agent: fortrabbit"
```

A successful response returns a JSON object with a `publicId`. If no secret is configured, remind the user to push to their connected Git remote to trigger a deployment.

### SSH exec

Run a remote command non-interactively:

```bash
ssh APP_ENV_ID@ssh.REGION.frbit.app COMMAND
```

Examples: `php artisan migrate`, `php craft clear-caches`, `composer install`

### Database pull

fortrabbit databases are only reachable via SSH tunnel — direct remote connections are blocked.

```bash
# Terminal 1 — open tunnel, keep running
ssh -N -L 13306:mysql:3306 APP_ENV_ID@ssh.REGION.frbit.app

# Terminal 2 — dump and import
mysqldump --set-gtid-purged=OFF --no-tablespaces \
  -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID > fortrabbit-backup.sql
mysql -uLOCAL_DB_USER -p LOCAL_DB_NAME < fortrabbit-backup.sql
```

MySQL credentials are in the dashboard under **Environment → MySQL → Access**.

### Database push

```bash
# Terminal 1 — open tunnel (see above)

# Terminal 2 — dump local and push via tunnel
mysqldump --set-gtid-purged=OFF -uLOCAL_DB_USER -p LOCAL_DB_NAME > local-dump.sql
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID < local-dump.sql
```

### Content sync

Rsync user-generated content between local and remote. Paths vary by framework:

| Framework | Path |
|-----------|------|
| Laravel | `storage/app/public/` |
| Craft CMS | check `config/project/` YAML or `config/filesystems.php` for each volume's local path |
| Kirby | `content/` |
| Statamic | `content/`, `users/`, `public/assets/` |
| WordPress | `wp-content/uploads/` |

```bash
# Down — pull from remote
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./UPLOADS_PATH ./UPLOADS_PATH

# Up — push to remote
rsync -av ./UPLOADS_PATH APP_ENV_ID@ssh.REGION.frbit.app:./UPLOADS_PATH
```

Add `-n` for a dry run before syncing. See `references/content-sync.md` for per-framework details.

## Safety rules

- Show every SSH/rsync/curl command before executing.
- `db push` overwrites the live database — ask "This will overwrite the remote database. Confirm?" and wait.
- `db pull` overwrites local data — warn before proceeding.
- Never store passwords in files.
- On SSH failure, direct the user to register their SSH key at https://dash.fortrabbit.com/you/ssh-keys

## Tools allowed

- `bash` / shell execution (for SSH, rsync, curl, mysqldump)
- File read (to detect project type and read config)
