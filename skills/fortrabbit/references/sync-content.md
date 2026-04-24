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

After running the grep, resolve the results:

```
IF exactly one local volume path found
  → Use it. Show the rsync command and ask: "Ready to sync this path?"

IF multiple local volume paths found
  → List them and ask: "I found these volume paths. Which ones should I sync?
      1) path/one
      2) path/two
      (Enter numbers separated by commas, e.g. 1,2 — or type 'all')"
    Run rsync for each selected path. Show each command before running it.

IF no paths found
  → Ask: "I couldn't find the volume paths automatically. What is the path to your uploads folder? (e.g. web/uploads)"
    Use the path provided. Show the rsync command and ask for confirmation.
```

**Step 2 — sync each local volume path:**

```shell
# sync content up: push local uploads to remote for Craft CMS
rsync -av ./VOLUME_PATH/ APP_ENV_ID@ssh.REGION.frbit.app:./VOLUME_PATH/

# sync content down: pull remote uploads to local for Craft CMS
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./VOLUME_PATH/ ./VOLUME_PATH/
```

Repeat for each selected volume. Apply the dry-run gate from [sync.md](sync.md) before each rsync.

---

## Kirby CMS

The content for Kirby CMS is stored with the `content` folder:

```shell
# Sync content up: sync only content folder for Kirby CMS
rsync -av ./content/ APP_ENV_ID@ssh.REGION.frbit.app:./content/

# Sync content down: pull content folder for Kirby CMS
rsync -av APP_ENV_ID@ssh.REGION.frbit.app:./content/ ./content/
```

The `media` folder may also need syncing — apply the same pattern.

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

# Sync content down: pull remote content to local for Statamic
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
- Syncing down overwrites local files. Always warn the user before running a down-sync and require explicit confirmation.
- Always show the full rsync command before running it. Apply the dry-run gate from [sync.md](sync.md) for any sync that includes `--delete` or is a first-time sync.
- For rsync flags and dry-run usage, see [sync.md](sync.md).

After syncing content up, review changes in your browser. See [browser-review.md](browser-review.md) for test domain instructions.
