# Craft CMS: configure for local and fortrabbit environments

Use environment variables to make the same `.env` configuration work locally and on fortrabbit. Git deployment is the preferred method for Craft CMS.

## Deployment: Git is preferred

Craft CMS works best with Git deployment on fortrabbit:

### Set up Git deployment

1. Connect your GitHub repository to fortrabbit (see [setup-git-github.md](setup-git-github.md))
2. Push changes to trigger automatic deployment

### Post-deploy commands

These typically run after each deployment:

```bash
php craft migrate/all
php craft project-config/apply
php craft clear-caches/all
```

When the app environment on fortrabbit is pre-configured for Craft CMS, it will work out of the box.

## Content sync

When you use Git, asset volumes are typically excluded from source control and kept separate from the repository. Craft CMS asset volume paths are not fixed. Check your project config for the actual local asset folder before syncing:

- `config/project/` may define volume base paths
- `config/app.php` or `config/general.php` may contain volume URL/path settings

If you are not using Craft asset volumes, sync the folder(s) that contain your asset files:

```bash
rsync -av ./path/to/your/assets/ APP_ENV_ID@ssh.REGION.frbit.app:./path/to/your/assets/
```

For detailed rsync commands and content sync guidance, see [sync-content.md](sync-content.md).

## After deployment: Database updates

For database pull/push operations, see [database.md](database.md).

## Notes

- `.env` should be in `.gitignore`, ENV vars on fortrabbit are edited in the dashboard
- Craft CMS uses project config (`config/project/*.yaml`) for environment-agnostic settings
- Asset volumes can be configured to use remote storage (S3, etc.)
- For multi-environment setups, use Craft's environment-specific config files

After making changes, review them in your browser. See [browser-review.md](browser-review.md) for test domain instructions.
