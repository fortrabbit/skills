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

## Fortrabbit environment setup

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

For full rsync sync, see [sync-all.md](sync-all.md).

## After code deployment: Update the database

After deploying code changes, you may need to update the database. For detailed database pull/push operations, see [database.md](database.md).

## Notes

- `DB_HOST` on fortrabbit is typically an internal host name, not `localhost`.
- The database name and user on fortrabbit are often the environment ID, but using the `FORTRABBIT_DB_*` variables keeps your config portable.
- If you use a hosting-specific setup or a local container, set the local fallback values to match that environment.

