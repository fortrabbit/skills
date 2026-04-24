# Sync all files via rsync

Use this when Git and GitHub are not available or the user prefers quick rsync. This flow will use rsync to upload or download the entire project via SSH. It will include all files, also the vendor folder.

## sync up: Upload all files to remote

```bash
rsync -av \
  --exclude='.git/' \
  --exclude='.claude/' \
  --exclude='.fortrabbit' \
  --exclude='.env' \
  --exclude='.env.local' \
  --exclude='.DS_Store' \
  --exclude='node_modules/' \
  ./ APP_ENV_ID@ssh.REGION.frbit.app:
```

## sync down: Download all files from remote

```bash
rsync -av APP_ENV_ID@ssh.REGION.frbit.app: ./
```

> **Warning:** Downloading overwrites local files. Confirm with the user before running a down-sync.

## Dry-run gate

Apply this rule before running any rsync command:

```
IF the rsync command includes --delete
  OR this is the first sync to this remote path
  → Always run a dry run first. Show the output before proceeding.

    rsync -avn [all other flags] SOURCE DESTINATION

    Say: "This preview shows what will be transferred. No files have been changed yet."
    Ask: "Does this look right? Ready to sync for real?"

    IF yes → rerun the same command without the -n flag
    IF no  → Ask: "What should I change?"

ELSE (routine incremental sync, no --delete, remote path has been synced before)
  → Ask: "Ready to sync?" and proceed on confirmation.
```

## Common rsync flags

| Flag       | Meaning                                                          |
| ---------- | ---------------------------------------------------------------- |
| `-a`       | Archive: preserves permissions, timestamps, symlinks             |
| `-v`       | Verbose: shows what is being transferred                         |
| `-n`       | Dry run: preview without transferring                            |
| `--delete` | Remove remote files no longer present locally (use with caution) |
