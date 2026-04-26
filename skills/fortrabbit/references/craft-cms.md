# Craft CMS

Craft CMS uses a database and project config files. Git deployment is the preferred method on fortrabbit.

## Check local setup

If no Craft project exists yet, install one:

```bash
composer create-project craftcms/craft .
php craft setup
```

Requires an empty folder. If `.claude/` or `.fortrabbit` exists, install into a subdirectory first and move files up, or reinstall the skills globally.

## Choose a deployment strategy

Ask:

> "How do you want to deploy?
>   A) Git (recommended for real projects) — code in GitHub, auto-deploys on push
>   B) Rsync (recommended for demo) — sync all files directly without Git"

```
IF answer == A (Git)
  → Load setup-git-github.md

IF answer == B (rsync)
  → Load sync.md

IF unsure
  → Ask: "Are you working solo or with a team?"
    IF solo → recommend B (rsync), load sync.md
    IF team → recommend A (Git), load setup-git-github.md
```

**Option A — Git deployment (recommended for teams)**
Code and project config live in Git. Deployments are triggered by pushing to GitHub with automatic post-deploy commands (migrations, cache clearing). Best for teams and projects with evolving schema.

**Option B — Full rsync**
All files are transferred via rsync. No Git required. Best for solo developers.

---

## Option A: Git deployment

### Set up Git deployment

1. Connect your GitHub repository to fortrabbit (the setup guide loaded above walks you through the steps).
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

For detailed asset sync commands, use `/fortrabbit content sync`.

## Option B: Full rsync

For projects without Git, deploy all files via rsync. Use `/fortrabbit sync` for the full workflow.

## After deployment: Database updates

After deploying code changes, you may need to update the database. Use `/fortrabbit db pull` or `/fortrabbit db push`.

## Notes

- `.env` should be in `.gitignore`; ENV vars on fortrabbit are edited in the dashboard.
- Craft CMS uses project config (`config/project/*.yaml`) for environment-agnostic settings.
- Asset volumes can be configured to use remote storage (S3, etc.).
- After deployment, check your site at `https://APP_ENV_ID.REGION.frbit.app`. Use `/fortrabbit review` for a full response check with error diagnosis.
