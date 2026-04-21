# Content sync via rsync

Git deployment handles code. User-generated content (uploads, images, flat files) is separate and must be synced with rsync over SSH.

---

## Laravel

Laravel stores user uploads in `storage/app/public/`. Sync only that directory:

```shell
# sync content up: push local uploads to remote for Laravel
rsync -av ./storage/app/public/ APP_ENV_ID@ssh.REGION.frbit.app:./storage/app/public/

# sync content down: pull remote uploads to local for Laravel
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
# sync content up: push local uploads to remote for Craft CMS
rsync -av ./VOLUME_PATH/ APP_ENV_ID@ssh.REGION.frbit.app:./VOLUME_PATH/

# sync content down: pull remote uploads to local for Craft CMS
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./VOLUME_PATH/ ./VOLUME_PATH/
```

Repeat for each volume that uses local storage.

---

## Kirby CMS

The content for Kirby CMS is stored with the `content` folder:

```shell
# Sync content up: sync only content folder for Kirby CMS
rsync -av ./content/ APP_ENV_ID@ssh.REGION.frbit.app:./content/

# Sync content up: sync only content folder for Kirby CMS
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./content/ ./content/
```

Likely the `media` folder needs a treatment like this too.s 

---

## Statamic

The content directories to sync when only syncing content:

```shell
# Sync content up: push local content to remote for Statamic
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

# Sync content down:: pull remote content to local for Statamic
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

WordPress uploads live in `wp-content/uploads/`.

```shell
# Sync content up: push local uploads to remote
rsync -av ./wp-content/uploads/ APP_ENV_ID@ssh.REGION.frbit.app:./wp-content/uploads/

# Sync content down: pull remote uploads to local
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./wp-content/uploads/ ./wp-content/uploads/
```

---

## Notes

- rsync uses your local SSH key — the same key registered in the dashboard.
- Syncing down overwrites local files. Warn the user before running a down-sync.
- For rsync flags and dry-run usage, see [sync.md](sync.md).

After syncing content up, review changes in your browser. See [browser-review.md](browser-review.md) for test domain instructions.
