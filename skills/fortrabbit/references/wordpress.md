# WordPress: configure for local and fortrabbit environments

Use environment variables to make the same `wp-config.php` work locally and on fortrabbit.

## Database constants with env var fallbacks

Add these definitions to `wp-config.php` near the other database settings:

```php
define('DB_HOST',     getenv('FORTRABBIT_DB_HOST')     ?: 'your_local_db_host');
define('DB_NAME',     getenv('FORTRABBIT_DB_NAME')     ?: 'your_local_db_name');
define('DB_USER',     getenv('FORTRABBIT_DB_USER')     ?: 'your_local_db_user');
define('DB_PASSWORD', getenv('FORTRABBIT_DB_PASSWORD') ?: 'your_local_db_password');
```

This makes WordPress use the fortrabbit environment variables when available, and fall back to local placeholders when they are not.

## URL constants with env var fallbacks

Add these definitions to `wp-config.php` after the database settings to control WordPress URLs:

```php
$_fortrabbit_domain = getenv('FORTRABBIT_MAIN_DOMAIN');
define('WP_HOME',    $_fortrabbit_domain ? 'https://' . $_fortrabbit_domain : 'http://your_local_dev_url');
define('WP_SITEURL', $_fortrabbit_domain ? 'https://' . $_fortrabbit_domain : 'http://your_local_dev_url');
```

Replace `your_local_dev_url` with your local development URL (e.g., `localhost:8080`, `myproject.test`).

## When URL constants are used

The `WP_HOME` and `WP_SITEURL` constants are evaluated on every WordPress page load and take precedence over any URL values stored in the database.

- **Database fallback**: WordPress stores `siteurl` and `home` values in the `wp_options` table, but these are only used when the constants are not defined.
- **Constant priority**: When `WP_SITEURL` and `WP_HOME` are defined in `wp-config.php`, WordPress ignores the database values entirely.
- **Installation impact**: During WordPress installation, if these constants are defined, they determine the initial database values. However, the constants always override the database afterward.
- **Migration safety**: This approach prevents URL issues when migrating between environments, as the constants dynamically set the correct URLs based on the environment.

**Source**: This behavior is documented in the official WordPress Codex and implemented in WordPress core (see `wp-includes/option.php` and `wp-includes/link-template.php`). The constants are checked before database queries for URL options.

## How this works

- On fortrabbit: the remote environment sets `FORTRABBIT_MAIN_DOMAIN` to your live domain, so WordPress uses HTTPS URLs.
- Locally: falls back to your local development URL with HTTP.
- This prevents WordPress from hardcoding URLs in the database and makes the same `wp-config.php` work in both environments.

## How this works

- On fortrabbit: the remote environment sets `FORTRABBIT_DB_HOST`, `FORTRABBIT_DB_NAME`, `FORTRABBIT_DB_USER`, and `FORTRABBIT_DB_PASSWORD` env vars.
- Locally: the same `wp-config.php` can use a local `.env` file or shell environment for development.
- The `?:` fallback allows local development without needing the remote env vars.

## Example local environment

If you use a local `.env` loader such as `vlucas/phpdotenv`, define the same variables locally using placeholders that match your local database:

```env
FORTRABBIT_DB_HOST=your_local_db_host
FORTRABBIT_DB_NAME=your_local_db_name
FORTRABBIT_DB_USER=your_local_db_user
FORTRABBIT_DB_PASSWORD=your_local_db_password
```

Then load them before WordPress boots, for example in `wp-config.php`:

```php
if (file_exists(__DIR__ . '/.env')) {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
    $dotenv->load();
}
```

## fortrabbit environment setup

On fortrabbit, configure the database credentials in the environment settings so the `FORTRABBIT_DB_*` variables are available to WordPress.

- Use the dashboard or deploy environment settings to set the variables.
- Do not commit secrets to Git.
- Keep `.env` in `.gitignore` for local development.

## Deployment options

After configuring WordPress for both environments, choose how to deploy your code changes:

### Option 1: Deploy via Git

If your project is connected to GitHub and the fortrabbit GitHub App:

1. Push your changes to GitHub: `git push origin main`
2. The fortrabbit GitHub App will automatically trigger a deployment
3. Check deployment status in the dashboard

For setup instructions, see [setup-git-github.md](setup-git-github.md).

### Option 2: Sync via rsync (recommended)

If Git deployment is not set up, sync files manually with rsync:

```bash
# Upload code to remote
rsync -av ./wp-content/themes/ APP_ENV_ID@ssh.REGION.frbit.app:./wp-content/themes/
rsync -av ./wp-content/plugins/ APP_ENV_ID@ssh.REGION.frbit.app:./wp-content/plugins/
# Add other directories as needed
```

For full rsync sync, see [sync.md](sync.md).

## After code deployment: Update the database

After deploying code changes, you may need to update the database. For detailed database pull/push operations, see [database.md](database.md).

## Notes

- `DB_HOST` on fortrabbit is typically an internal host name, not `localhost`.
- The database name and user on fortrabbit are often the environment ID, but using the `FORTRABBIT_DB_*` variables keeps your config portable.
- If you use a hosting-specific setup or a local container, set the local fallback values to match that environment.

