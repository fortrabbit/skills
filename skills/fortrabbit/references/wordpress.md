# WordPress

WordPress requires a database. Use environment variables to make the same `wp-config.php` work locally and on fortrabbit.

## Check local setup

Check whether a WordPress project exists in the current folder — see [software-detection.md](software-detection.md). If no project is found, check the local development environment first — see [local-development.md](local-development.md).

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

Add these definitions to `wp-config.php` near the other database settings:

```php
define('DB_HOST',     getenv('FORTRABBIT_DB_HOST')     ?: 'your_local_db_host');
define('DB_NAME',     getenv('FORTRABBIT_DB_NAME')     ?: 'your_local_db_name');
define('DB_USER',     getenv('FORTRABBIT_DB_USER')     ?: 'your_local_db_user');
define('DB_PASSWORD', getenv('FORTRABBIT_DB_PASSWORD') ?: 'your_local_db_password');
```

On fortrabbit, the `FORTRABBIT_DB_*` variables are set automatically. Locally, the fallback values are used.

### URL constants with env var fallbacks

Add these definitions to `wp-config.php` after the database settings:

```php
$_fortrabbit_domain = getenv('FORTRABBIT_MAIN_DOMAIN');
define('WP_HOME',    $_fortrabbit_domain ? 'https://' . $_fortrabbit_domain : 'http://your_local_dev_url');
define('WP_SITEURL', $_fortrabbit_domain ? 'https://' . $_fortrabbit_domain : 'http://your_local_dev_url');
```

Replace `your_local_dev_url` with your local development URL (e.g., `localhost:8080`, `myproject.test`). When these constants are defined in `wp-config.php`, WordPress ignores any URL values stored in the database.

## Choose a deployment strategy

**Option A — Sync via rsync (recommended)**
Sync files manually with rsync. For the full rsync workflow, see [sync.md](sync.md).

**Option B — Deploy via Git**
Git deployment is not recommended for WordPress. If your project is connected to GitHub and the fortrabbit GitHub App:

1. Push your changes to GitHub: `git push origin main`
2. The fortrabbit GitHub App will automatically trigger a deployment.
3. Check deployment status in the dashboard.

For setup instructions, see [setup-git-github.md](setup-git-github.md).

## After deployment: Update the database

After deploying code changes, you may need to update the database. For database pull/push operations, see [database.md](database.md).

## Notes

- `DB_HOST` on fortrabbit is typically an internal host name, not `localhost`.
- Keep `.env` in `.gitignore`; never commit secrets to Git.
- Review changes in the browser after deployment: [browser-review.md](browser-review.md).
