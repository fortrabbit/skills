# Kirby CMS: configure for local and fortrabbit environments

Kirby CMS works well with Git deployment on fortrabbit. Use environment variables in your Kirby config so the same project runs locally and remotely.

## Git deployment is preferred

For Kirby, Git deployment is the recommended workflow on fortrabbit.

- Store code, templates, and site config in Git.
- Keep `content/` and `site/accounts/` under Git if you want file-based content versioning.
- Avoid committing generated files and caches.

### Set up Git deployment

1. Connect your GitHub repository to fortrabbit. See [setup-git-github.md](setup-git-github.md).
2. Push changes to trigger deployment.
3. Verify the site on the test domain.

## Content and asset sync

Kirby stores content in `content/` and media in `site/assets/` or `content/` depending on configuration.

If asset or upload folders are not in Git, sync them with rsync:

```bash
# Sync Kirby content and assets
rsync -av ./content/ APP_ENV_ID@ssh.REGION.frbit.app:./content/
rsync -av ./site/assets/ APP_ENV_ID@ssh.REGION.frbit.app:./site/assets/
```

If your project stores media elsewhere, update the source and destination paths accordingly.

For detailed content sync guidance, see [sync-content.md](sync-content.md).

## Notes

- Use `your_local_dev_url` to match your local development environment, not a fixed hostname.
- Kirby is file-based, so content sync and Git strategy should match your project structure.
- Keep `.env` out of Git, and only commit non-secret config.
- Review changes in the browser after deployment: [browser-review.md](browser-review.md).
