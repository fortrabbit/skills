# Running remote commands via SSH

## How SSH exec works on fortrabbit

You can execute single commands on a fortrabbit environment without opening an interactive shell. This is done with SSH command execution:

```shell
ssh APP_ENV_ID@ssh.REGION.frbit.app 'COMMAND'
```

> **Important:** Always use the PHP binary explicitly. Do not rely on shebangs or `./artisan`. The runtime matches your app's configured PHP version.

## Interactive shell

For multi-step debugging or exploration:

```shell
ssh APP_ENV_ID@ssh.REGION.frbit.app
```

When connected, you'll see the fortrabbit welcome banner. Type `exit` when done.

## Limitations

- Not a root shell — you cannot install packages
- Resource-intensive commands share CPU/memory with your web application
- Jobs (workers, crons) are managed via the dashboard, not the shell

---

## Laravel commands

```shell
# Run database migrations
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan migrate --force'

# Clear all caches
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan cache:clear'
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan config:cache'
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan route:cache'
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan view:cache'

# Clear config cache (useful after env var changes)
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan config:clear'

# Run a custom artisan command
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan YOUR:COMMAND'

# Check queue status
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan queue:failed'

# Run Composer (use install, not update)
ssh APP_ENV_ID@ssh.REGION.frbit.app 'composer install --no-dev --optimize-autoloader'
```

## Craft CMS commands

```shell
# Apply project config changes
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php craft project-config/apply'

# Clear all caches
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php craft clear-caches/all'

# Run database migrations
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php craft migrate/all'

# Resave all entries
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php craft resave/entries'

# Update search indexes
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php craft search/index-everything'

# Run a queue job
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php craft queue/run'
```

## Statamic commands

```shell
# Warm the Stache (content cache)
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan statamic:stache:warm'

# Clear Statamic caches
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan statamic:clear-site'

# Run migrations
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php artisan migrate --force'
```

## Generic PHP

```shell
# Run a PHP script
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php path/to/script.php'

# Run Composer
ssh APP_ENV_ID@ssh.REGION.frbit.app 'composer install --no-dev'

# Check PHP version
ssh APP_ENV_ID@ssh.REGION.frbit.app 'php --version'

# Check disk usage
ssh APP_ENV_ID@ssh.REGION.frbit.app 'du -sh ./'
```

After running SSH commands that modify your application, review the changes in your browser. See [browser-review.md](browser-review.md) for test domain instructions.
