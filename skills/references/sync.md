# Sync all files via rsync

## Check for Git

First, determine if the current directory is a Git repository:

```bash
ls -la .git
```

If a `.git` directory exists, the folder is a Git repository.

## If Git repository

### Check for GitHub remote

Check if the repository is connected to a GitHub remote:

```bash
git remote -v
```

Look for an `origin` remote pointing to `github.com`.

### If connected to GitHub

Suggest deployment via Git push or deploy hook. See [deploy.md](deploy.md) for deployment commands and options.

### If not connected to GitHub

Fall back to rsync for syncing all files.

## Rsync commands

When using rsync to sync all files, use the following commands.

### Upload all files to remote

```bash
rsync -av \
  --exclude='.git/' \
  --exclude='.claude/' \
  --exclude='.env' \
  --exclude='.env.local' \
  --exclude='.DS_Store' \
  --exclude='node_modules/' \
  ./ {{app-env-id}}@ssh.{{region}}.frbit.app:
```

### Download all files from remote

```bash
rsync -av {{app-env-id}}@ssh.{{region}}.frbit.app: ./
```

For more rsync options and details, see the [rsync documentation](https://docs.fortrabbit.com/dev/how-to/rsync#usage).

