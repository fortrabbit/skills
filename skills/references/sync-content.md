# Content sync via rsync

Git deployment handles code. User-generated content (uploads, images, flat files) is separate and must be synced with rsync over SSH.

---

## Laravel

Laravel stores user uploads in `storage/app/public/`. Sync only that directory:

```shell
# UP: push local uploads to remote
rsync -av ./storage/app/public/ APP_ENV_ID@ssh.REGION.frbit.app:./storage/app/public/

# DOWN: pull remote uploads to local
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./storage/app/public/ ./storage/app/public/
```

---

## Craft CMS

Craft CMS stores uploads in paths defined by its volume configuration — there is no fixed default. Each volume has its own base path set in the filesystem config.

**Step 1 — find the volume paths:**

Check `config/project/` YAML files (most reliable, always present):
```shell
grep -r "basePath\|path" config/project/
```
Look for local filesystem entries. The value is often an env var alias like `$ASSETS_PATH` or `@webroot/uploads`.

Also check `config/filesystems.php` if it exists:
```php
// The 'path' or 'root' key holds the base path
'myFilesystem' => [
    'driver' => 'local',
    'path' => getenv('ASSETS_PATH'),  // ← this is the path
],
```

Check `.env` for any env vars those keys reference. The path is often something like `web/uploads`, `web/media`, or a custom directory name.

Volumes backed by a remote filesystem (S3, etc.) do not need rsync — skip those.

**Step 2 — sync each local volume path:**

```shell
# UP: push local uploads to remote
rsync -av ./VOLUME_PATH/ APP_ENV_ID@ssh.REGION.frbit.app:./VOLUME_PATH/

# DOWN: pull remote uploads to local
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./VOLUME_PATH/ ./VOLUME_PATH/
```

Repeat for each volume that uses local storage.

---

## Kirby CMS

Kirby stores content in flat files in `content/` and media in `media/`.

```shell
# UP: push local content to remote
rsync -av ./ APP_ENV_ID@ssh.REGION.frbit.app:

# DOWN: pull remote content to local
rsync -av APP_ENV_ID@ssh.REGION.frbit.app: ./
```

Kirby rsync syncs the entire project root. The vendor folder is included — this usually works if your local PHP version matches the remote. A more selective approach is to only sync content:

```shell
# UP: sync only content folder
rsync -av ./content/ APP_ENV_ID@ssh.REGION.frbit.app:./content/

# DOWN: sync only content folder
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./content/ ./content/
```

---

## Statamic

Statamic separates code (Git-deployed) from content (rsync). The content directories to sync:

```shell
# UP: push local content to remote
rsync -avR \
  ./content \
  ./users \
  ./resources/blueprints \
  ./resources/fieldsets \
  ./resources/forms \
  ./resources/users \
  ./storage/forms \
  ./public/assets \
  APP_ENV_ID@ssh.REGION.frbit.app:./

# DOWN: pull remote content to local
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./content' ./
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./users' ./
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./resources/blueprints' ./resources/
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./resources/fieldsets' ./resources/
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./resources/forms' ./resources/
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./resources/users' ./resources/
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./storage/forms' ./storage/
rsync -av 'APP_ENV_ID@ssh.REGION.frbit.app:./public/assets' ./public/
```

Only include the folders that exist in your project.

---

## WordPress

WordPress uploads live in `wp-content/uploads/`. Sync only the uploads folder to avoid overwriting plugins and themes managed by Git:

```shell
# UP: push local uploads to remote
rsync -av ./wp-content/uploads/ APP_ENV_ID@ssh.REGION.frbit.app:./wp-content/uploads/

# DOWN: pull remote uploads to local
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./wp-content/uploads/ ./wp-content/uploads/
```

---

## Generic rsync flags

| Flag | Meaning |
|------|---------|
| `-a` | Archive mode: preserves permissions, timestamps, symlinks |
| `-v` | Verbose: shows what is being transferred |
| `-R` | Relative paths: preserves directory structure |
| `-n` | Dry run: shows what would be synced without doing it |
| `--delete` | Remove remote files that no longer exist locally (use with caution) |

## Dry run first

When unsure, add `-n` to preview what will be transferred:

```shell
rsync -avn ./content/ APP_ENV_ID@ssh.REGION.frbit.app:./content/
```

## Notes

- rsync uses your local SSH key — the same key registered in the dashboard.
- Syncing down overwrites local files. Warn the user before running a down-sync.
- Do not sync the `vendor/` folder unless you intentionally want to overwrite Composer dependencies on the remote.

After syncing content, review the changes in your browser. See [browser-review.md](browser-review.md) for test domain instructions.
