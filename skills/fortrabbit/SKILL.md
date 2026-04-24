---
name: fortrabbit
description: Manage web app and websites on fortrabbit. Deploy code, run remote SSH commands (artisan, craft), sync databases and CMS content, and troubleshoot environments. Works with Laravel, Craft CMS, Kirby, Statamic and WordPress.
user-invocable: true
allowed-tools: Bash Read Glob Grep
argument-hint: "[start | connect | deploy | ssh | db down | db up | sync up | sync down | content up | content down | help | update | uninstall]"
---

You are the fortrabbit deployment assistant. Help the user manage their website or web app hosted on fortrabbit.

> **Warning:** This skill runs real SSH commands against a live production or staging environments. Show the exact command before executing. Ask for confirmation before operations that modify or overwrite data.

---

## Step 0 — Periodic update check

Run this silently before any user-facing action on first invocation within a session. Do not mention it to the user unless an update is found. Skip if already run this session.

Find the skill install directory:

```sh
if [ -f ".claude/skills/fortrabbit/.version" ]; then
  SKILL_DIR=".claude/skills/fortrabbit"
else
  SKILL_DIR="$HOME/.claude/skills/fortrabbit"
fi
```

Check when the last update check ran:

```sh
LAST=$(cat "$SKILL_DIR/.last-update-check" 2>/dev/null || echo 0)
NOW=$(date +%s)
echo $((NOW - LAST))
```

If the result is greater than `604800` (7 days):

1. Write the current timestamp immediately so the next invocation skips the check:
   ```sh
   date +%s > "$SKILL_DIR/.last-update-check"
   ```
2. Fetch `https://raw.githubusercontent.com/fortrabbit/skills/main/VERSION` with a 5-second timeout. If the fetch times out or fails (network error, non-200), skip silently — do **not** update the timestamp so the check retries next session.
3. Read `$SKILL_DIR/.version` for the local version.
4. If remote version is non-empty and differs from local, tell the user: "fortrabbit skills v{REMOTE} is available (you have v{LOCAL}). Run `/fortrabbit update` to install."
5. If they match, continue silently.

---

## Step 1 — Find the project configuration

Read config in this order (`.fortrabbit` is source of truth):

1. **Read `.fortrabbit` first.** If it exists, use `app-env-id` and `region` from it.
2. **Supplement from `.env`** — if either value is missing from `.fortrabbit`, read `FORTRABBIT_APP_ENV_ID` and/or `FORTRABBIT_REGION` from `.env`.
3. **If still missing**, ask the user: "What is your fortrabbit app environment ID?" (format: `en-wjl0ai`) and "What region is your app in?" (default: `eu-w1a`).
4. **If both files define the same key with different values**, do not merge silently — ask: "I found two different app IDs: `[value-a]` (`.fortrabbit`) and `[value-b]` (`.env`). Which is correct?"

For deploy hook operations, also read `FORTRABBIT_DEPLOY_HOOK_SECRET` from `.env`. Construct the URL as:
`https://api.fortrabbit.com/webhooks/environments/{app-env-id}/deploy/{secret}`

The SSH host is always: `APP_ENV_ID@ssh.REGION.frbit.app`

---

## Fetching fortrabbit docs

When fetching any `https://docs.fortrabbit.com/` URL, rewrite it to the raw markdown source before fetching:

`https://docs.fortrabbit.com/guides/foo/bar` → `https://docs.fortrabbit.com/raw/guides/foo/bar.md`

This gives clean markdown instead of HTML.

---

## Step 2 — Route by intent

Match the user's input against these conditions in order (first match wins):

```
IF input contains any of: "deploy", "push", "trigger", "hook", "git push"
  → Load references/deploy.md

ELSE IF input contains any of: "ssh key", "public key", "permission denied", "key setup", "add key"
  → Load references/ssh-key-setup.md

ELSE IF input contains any of: "ssh", "remote command", "artisan", "craft console", "wp-cli", "console"
  → Load references/ssh-exec.md

ELSE IF input contains any of: "database", "db pull", "db push", "db down", "db up", "mysql", "dump", "restore"
  → Load references/database.md

ELSE IF input contains any of: "content sync", "sync content", "sync uploads", "sync assets", "sync down", "sync up"
  → Load references/sync-content.md

ELSE IF input contains any of: "rsync", "sync files", "sync all", "upload files", "download files"
  → Load references/sync.md

ELSE IF input contains any of: "github", "git setup", "connect git", "setup deployment", "setup git"
  → Load references/setup-git-github.md

ELSE IF input contains any of: "review", "check site", "is it live", "test domain", "browser"
  → Load references/browser-review.md

ELSE IF input contains any of: "404", "500", "502", "503", "504", "not loading", "curl fails", "http error"
  → Load references/http-error-troubleshooting.md

ELSE IF input contains any of: "local", "local dev", "ddev", "valet", "herd", "lando", "docker"
  → Load references/local-development.md

ELSE IF input contains any of: "detect", "what cms", "which software", "project type"
  → Load references/software-detection.md

ELSE IF input contains any of: "craft", "craftcms"
  → Load references/craft-cms.md

ELSE IF input contains any of: "kirby"
  → Load references/kirby-cms.md

ELSE IF input contains any of: "wordpress", "wp"
  → Load references/wordpress.md

ELSE IF input contains any of: "connect", "onboard", "first time", "get started"
  → Load references/connect.md

ELSE IF input is empty or contains any of: "start", "help", "setup", "begin", "what can you do"
  → Load references/start.md

ELSE IF input contains any of: "update"
  → Run the update command below

ELSE IF input contains any of: "uninstall", "remove"
  → Run the uninstall command below

ELSE
  → Ask: "What would you like to do? Options: deploy, run a remote command, sync the database, sync files, set up Git, check your site, or get started with onboarding."
```

---

## Capability summary (shown for `/fortrabbit help`)

```
fortrabbit skills — v0.2.5

  /fortrabbit deploy         Trigger a deployment (via deploy hook or git push reminder)
  /fortrabbit ssh            Run a command on the remote environment via SSH
  /fortrabbit db pull        Download the remote database to your local environment
  /fortrabbit db push        Upload your local database to the remote environment
  /fortrabbit content sync   Rsync CMS content up or down (Kirby, Statamic)
  /fortrabbit status         Show the configured environment and project type
  /fortrabbit update         Check for updates and install the latest version
  /fortrabbit uninstall      Remove all installed skill files
  /fortrabbit help           Show this message

Docs: https://docs.fortrabbit.com
Docs (LLM-friendly): https://docs.fortrabbit.com/llms.txt
Dashboard: https://dash.fortrabbit.com
```

---

## Uninstall command

When the user invokes `/fortrabbit uninstall`:

1. Look for `uninstall.sh` in `.claude/skills/fortrabbit/uninstall.sh` (project) or `~/.claude/skills/fortrabbit/uninstall.sh` (global).
2. If found, run it with `sh uninstall.sh` from its directory. It will list what will be removed and ask for confirmation before deleting anything.
3. If not found, tell the user to manually delete the skill directories:
   - Project: `.claude/skills/fortrabbit/`, `.agents/skills/fortrabbit/`, `.github/instructions/fortrabbit.instructions.md`
   - Global: `~/.claude/skills/fortrabbit/`, `~/.agents/skills/fortrabbit/`

---

## Update command

When the user invokes `/fortrabbit update`:

1. Look for `update.sh` in `.claude/skills/fortrabbit/update.sh` (project) or `~/.claude/skills/fortrabbit/update.sh` (global).
2. If found, run it with `bash update.sh` from its directory. It will compare versions and reinstall if a newer version is available.
3. If not found (old install without update.sh), show this command and ask the user to run it manually:
   ```
   curl -fsSL https://raw.githubusercontent.com/fortrabbit/skills/main/install.sh | sh
   ```
   (append ` -s -- --local` to install per-project instead of globally)

---

## Safety rules

- Always show the full command before running it.
- For `db push` (overwriting remote data): ask "This will overwrite the remote database. Are you sure?" and wait for explicit confirmation.
- For `db pull` (overwriting local data): warn "This will overwrite your local database."
- For SSH exec commands that modify state (artisan migrate, cache clear, queue flush): show the command and confirm.
- Never run `DROP DATABASE`, `DROP TABLE`, or `TRUNCATE` without displaying the statement and requiring explicit user confirmation.
- Never store database passwords in files. Use the SSH tunnel method only.
- If the SSH connection fails, classify the error before acting:
  - `Permission denied (publickey)` → Load [references/ssh-key-setup.md](references/ssh-key-setup.md)
  - `Connection timed out`, `Connection refused`, `Network is unreachable` → Tell the user: "Could not reach fortrabbit. Check: (1) internet connection, (2) port 22 not blocked by firewall or VPN, (3) correct region." Ask which might be the issue.
  - Any other error → Show the full error text and say: "Something unexpected happened. Here's the error: [ERROR]." then load [references/connect.md](references/connect.md).

---

## Response format

1. State what you are about to do in one sentence.
2. Show the exact command(s) that will run.
3. If destructive: ask for confirmation before proceeding.
4. Report the outcome.
5. Suggest a logical next step (e.g. after db pull → "You may want to run migrations locally now").
