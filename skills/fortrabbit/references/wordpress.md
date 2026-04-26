# WordPress

WordPress requires a database. Use environment variables to make the same `wp-config.php` work locally and on fortrabbit.

## Check local setup

If no WordPress project exists yet, DDEV is the recommended local setup:

```bash
ddev config --project-type=wordpress
ddev start
ddev wp core download
ddev wp config create --dbname=db --dbuser=db --dbpass=db --dbhost=db
ddev wp core install --url=https://your-project.ddev.site --title="My Site" --admin_user=admin --admin_password=admin --admin_email=admin@example.com
```

## Local configuration

### Database constants with env var fallbacks

Before editing `wp-config.php`, check whether it already defines `DB_HOST`, `DB_NAME`, `DB_USER`, or `DB_PASSWORD`:

```
IF wp-config.php already defines these constants as hardcoded values
  → Say: "I'll replace the hardcoded database constants with env-var-based definitions. Here's what I'll change:"
    Show the before/after diff. Ask: "OK to apply?"
    IF yes → make the edit
    IF no  → show the snippet and ask the user to apply it manually

IF wp-config.php does not define these constants yet
  → Say: "I'll add the database constants to wp-config.php. Here's what will be added:"
    Show the snippet. Ask: "OK to add this near the database settings section?"
    IF yes → make the edit
```

Add (or replace) these definitions in `wp-config.php` near the database settings:

```php
define('DB_HOST',     getenv('FORTRABBIT_DB_HOST')     ?: 'your_local_db_host');
define('DB_NAME',     getenv('FORTRABBIT_DB_NAME')     ?: 'your_local_db_name');
define('DB_USER',     getenv('FORTRABBIT_DB_USER')     ?: 'your_local_db_user');
define('DB_PASSWORD', getenv('FORTRABBIT_DB_PASSWORD') ?: 'your_local_db_password');
```

Replace `your_local_*` values with your actual local database credentials. On fortrabbit, the `FORTRABBIT_DB_*` variables are set automatically in the dashboard.

### URL constants with env var fallbacks

Same process — check for existing `WP_HOME` and `WP_SITEURL` definitions before adding:

```
IF wp-config.php already defines WP_HOME or WP_SITEURL as hardcoded values
  → Show the before/after diff and ask for confirmation before replacing.

IF not yet defined
  → Show the snippet and ask: "OK to add these after the database settings?"
```

Add after the database constants:

```php
$_fortrabbit_domain = getenv('FORTRABBIT_MAIN_DOMAIN');
define('WP_HOME',    $_fortrabbit_domain ? 'https://' . $_fortrabbit_domain : 'http://your_local_dev_url');
define('WP_SITEURL', $_fortrabbit_domain ? 'https://' . $_fortrabbit_domain : 'http://your_local_dev_url');
```

Replace `your_local_dev_url` with your local development URL (e.g., `localhost:8080`, `myproject.test`). When these constants are defined in `wp-config.php`, WordPress ignores any URL values stored in the database.

## Choose a deployment strategy

Ask:

> "How do you want to deploy?
>   A) Rsync (recommended for WordPress) — sync files directly, no Git required
>   B) Git — push code via GitHub (not typical for WordPress, but supported)"

```
IF answer == A (rsync)
  → Load sync.md

IF answer == B (Git)
  → Confirm: "Git deployment for WordPress is uncommon. Plugin and theme files are usually committed, which conflicts with standard WordPress practices. Are you sure you want Git deployment?"
    IF yes → Load setup-git-github.md
    IF no  → Load sync.md

IF unsure
  → Recommend A (rsync) as the standard WordPress workflow. Load sync.md.
```

**Option A — Sync via rsync (recommended)**
Sync files manually with rsync. Use `/fortrabbit sync` for the full workflow.

**Option B — Deploy via Git**
Git deployment is not recommended for WordPress. If your project is connected to GitHub and the fortrabbit GitHub App:

1. Push your changes to GitHub: `git push origin main`
2. The fortrabbit GitHub App will automatically trigger a deployment.
3. Check deployment status in the dashboard.

For setup instructions, use `/fortrabbit deploy` and follow the Git setup flow.

## After deployment: Update the database

After deploying code changes, you may need to update the database. Use `/fortrabbit db pull` or `/fortrabbit db push`.

## Notes

- `DB_HOST` on fortrabbit is typically an internal host name, not `localhost`.
- Keep `.env` in `.gitignore`; never commit secrets to Git.
- After deployment, check your site at `https://APP_ENV_ID.REGION.frbit.app`. Use `/fortrabbit review` for a full response check with error diagnosis.
