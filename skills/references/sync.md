# Sync all files via rsync

Use this when Git and GitHub are not available. For Git-based deployment, see [deploy.md](deploy.md).

## Upload all files to remote

```bash
rsync -av \
  --exclude='.git/' \
  --exclude='.claude/' \
  --exclude='.env' \
  --exclude='.env.local' \
  --exclude='.DS_Store' \
  --exclude='node_modules/' \
  ./ APP_ENV_ID@ssh.REGION.frbit.app:
```

## Download all files from remote

```bash
rsync -av APP_ENV_ID@ssh.REGION.frbit.app: ./
```

> **Warning:** Downloading overwrites local files. Confirm with the user before running a down-sync.

## Common rsync flags

| Flag | Meaning |
|------|---------|
| `-a` | Archive: preserves permissions, timestamps, symlinks |
| `-v` | Verbose: shows what is being transferred |
| `-n` | Dry run: preview without transferring |
| `--delete` | Remove remote files no longer present locally (use with caution) |

Run a dry run first when unsure:

```bash
rsync -avn ./ APP_ENV_ID@ssh.REGION.frbit.app:
```
