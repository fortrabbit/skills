# Statamic

Statamic is file-based like Kirby, but built on Laravel — so both file-sync and Git-based workflows are viable depending on your project.

## Check local setup

Check whether a Statamic project exists in the current folder — see [software-detection.md](software-detection.md). If no project is found, check the local development environment first — see [local-development.md](local-development.md).

## Install Statamic locally

If no Statamic project exists yet, install one:

```bash
composer create-project statamic/statamic .
```

Requires an empty folder. If `.claude/` or `.fortrabbit` exists, install into a subdirectory first and move files up, or reinstall the skills globally.

## Create a local admin user

Ask the user for their email address, suggest something you know about the user, then generate a random password and create the user non-interactively:

```bash
php please make:user EMAIL --super --password=GENERATED_PASSWORD
```

Show the generated credentials clearly so the user can save them. Note that the password will appear in shell history — they can change it later via the Statamic control panel or by running the command again. The password is hashed before storage.

## Choose a deployment strategy

Ask the user which workflow fits their project:

**Option A — Full rsync**
All files (including code and the `vendor` folder) are transferred via rsync. No Git required. Best for solo developers or quick demos where the server is the source of truth. See [sync.md](sync.md) for the full rsync workflow.

**Option B — Git deployment with rsync**
Code, templates, and config live in Git. Deployments are triggered by pushing to GitHub (with composer install, cache clearing). Content is synced separately via rsync. Best for team projects using version control.

---

## Option A: Full rsync

For projects without Git, deploy all files via rsync — including the hidden `.htaccess` file and the `vendor` folder. See [sync.md](sync.md) for the full rsync workflow — it covers uploading, downloading, dry runs, and common flags.

## Option B: Git deployment and rsync

- Store code, templates, and config in Git
- Keep `content/` out of Git and sync it with rsync
- Avoid committing generated files and caches

### Set up Git deployment

1. Connect your GitHub repository to fortrabbit. See [setup-git-github.md](setup-git-github.md).
2. Push changes to trigger deployment, if app is connected.
3. Verify the site on the test domain.

### Content sync

Statamic stores content as flat files in `content/`. Sync it with rsync:

```bash
# Push local content to fortrabbit
rsync -av ./content/ APP_ENV_ID@ssh.REGION.frbit.app:./content/

# Pull content from fortrabbit to local
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./content/ ./content/
```

For detailed content sync guidance, see [sync-content.md](sync-content.md).

## Notes

- Statamic is built on Laravel — if your project uses a database, set up MySQL and see [database.md](database.md).
- Keep `.env` out of Git; commit only non-secret config.
- Review changes in the browser after deployment: [browser-review.md](browser-review.md).
