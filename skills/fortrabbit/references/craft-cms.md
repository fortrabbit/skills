# Craft CMS

Craft CMS uses a database and project config files. Git deployment is the preferred method on fortrabbit.

## Check local setup

Check whether a Craft project exists in the current folder — see [software-detection.md](software-detection.md). If no project is found, check the local development environment first — see [local-development.md](local-development.md).

If no Craft project exists yet, install one:

```bash
composer create-project craftcms/craft my-craft-site
cd my-craft-site
php craft setup
```

## Choose a deployment strategy

Ask the user which workflow fits their project:

**Option A — Git deployment (recommended)**
Code and project config live in Git. Deployments are triggered by pushing to GitHub with automatic post-deploy commands (migrations, cache clearing). Best for teams and projects with evolving schema.

**Option B — Full rsync**
All files are transferred via rsync. No Git required. Best for solo developers. See [sync.md](sync.md) for the full rsync workflow.

---

## Option A: Git deployment

### Set up Git deployment

1. Connect your GitHub repository to fortrabbit. See [setup-git-github.md](setup-git-github.md).
2. Push changes to trigger automatic deployment.

### Post-deploy commands

These typically run after each deployment:

```bash
php craft migrate/all
php craft project-config/apply
php craft clear-caches/all
```

When the app environment on fortrabbit is pre-configured for Craft CMS, it will work out of the box.

### Content and asset sync

Asset volumes are typically excluded from source control. Craft CMS asset volume paths are not fixed — check your project config for the actual paths:

- `config/project/` may define volume base paths
- `config/app.php` or `config/general.php` may contain volume URL/path settings

Sync assets with rsync:

```bash
rsync -av ./path/to/your/assets/ APP_ENV_ID@ssh.REGION.frbit.app:./path/to/your/assets/
```

For detailed rsync commands and content sync guidance, see [sync-content.md](sync-content.md).

## Option B: Full rsync

For projects without Git, deploy all files via rsync. See [sync.md](sync.md) for the full rsync workflow.

## After deployment: Database updates

After deploying code changes, you may need to update the database. For database pull/push operations, see [database.md](database.md).

## Notes

- `.env` should be in `.gitignore`; ENV vars on fortrabbit are edited in the dashboard.
- Craft CMS uses project config (`config/project/*.yaml`) for environment-agnostic settings.
- Asset volumes can be configured to use remote storage (S3, etc.).
- Review changes in the browser after deployment: [browser-review.md](browser-review.md).
