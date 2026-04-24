# Kirby CMS

Kirby is a file-based CMS with no database. It works well with Git deployment on fortrabbit.

## Check local setup

Check whether a Kirby project exists in the current folder — see [software-detection.md](software-detection.md). If no project is found, check the local development environment first — see [local-development.md](local-development.md).

If no Kirby project exists yet, install one:

```bash
composer create-project getkirby/starterkit .
```

Requires an empty folder. If `.claude/` or `.fortrabbit` exists, install into a subdirectory first and move files up, or reinstall the skills globally.

## Choose a deployment strategy

Ask:

> "How do you want to deploy?
>   A) Rsync (recommended for solo) — sync all files directly without Git
>   B) Git + rsync (recommended for teams) — code in GitHub, content synced separately with rsync"

```
IF answer == A (rsync)
  → Load sync.md

IF answer == B (Git)
  → Load setup-git-github.md

IF unsure
  → Ask: "Are you working solo or with a team?"
    IF solo → recommend A (rsync), load sync.md
    IF team → recommend B (Git + rsync), load setup-git-github.md
```

**Option A — Full rsync**
All files (including code) are transferred via rsync. No Git required. Best for solo developers or projects where the server is the source of truth. See [sync.md](sync.md) for the full rsync workflow.

**Option B — Git deployment with rsync**
Code, templates, and config live in Git. Deployments are triggered by pushing to GitHub. Content is synced separately with rsync. Best when the team uses version control.

---

## Option A: Full rsync

For projects without Git, deploy all files via rsync. See [sync.md](sync.md) for the full rsync workflow — it covers uploading, downloading, dry runs, and common flags.

## Option B: Git deployment and rsync

- Store code and templates in Git
- Keep `content/` and `site/accounts/` out of Git and sync via rsync
- Avoid committing generated files and caches

### Set up Git deployment

1. Connect your GitHub repository to fortrabbit. See [setup-git-github.md](setup-git-github.md).
2. Push changes to trigger deployment, if app is connected.
3. Verify the site on the test domain.

### Content and asset sync

Kirby stores content in `content/` and media in `site/assets/` or `content/` depending on configuration. Sync them with rsync:

```bash
rsync -av ./content/ APP_ENV_ID@ssh.REGION.frbit.app:./content/
rsync -av ./site/assets/ APP_ENV_ID@ssh.REGION.frbit.app:./site/assets/
```

If your project stores media elsewhere, update the source and destination paths accordingly.

For detailed content sync guidance, see [sync-content.md](sync-content.md).

## Notes

- Kirby is file-based — content sync and Git strategy should match your project structure.
- Keep `.env` out of Git; commit only non-secret config.
- Review changes in the browser after deployment: [browser-review.md](browser-review.md).
