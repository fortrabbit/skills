# Detect local development setup in the current folder

This reference helps identify whether the current project already has a local development environment configured.

## Look for DDEV

DDEV is a strong signal that local development is configured.

- Check for the `.ddev` directory.
- Check for `.ddev/config.yaml`.

If both exist, DDEV is likely set up.

```shell
ls -a .ddev
cat .ddev/config.yaml
```

## Look for other container-based tooling

Check for other common local dev configuration files:

- `.lando.yml` or `lando.yml` — Lando project
- `docker-compose.yml` or `docker-compose.override.yml` — Docker Compose setup
- `.devcontainer/devcontainer.json` — VS Code dev container
- `Dockerfile` — containerized local development

## Look for editor or IDE configuration

These files may indicate a prepared local workflow rather than just source code:

- `.vscode/settings.json`
- `.vscode/launch.json`
- `.idea/` or `.idea/workspace.xml`

## Detecting local vs remote-only setup

A remote-only or simple deployment repo may still have code but lack local dev scaffolding.

If you find:

- `composer.json` but no `.ddev`, `docker-compose.yml`, or local config files
- `wp-config.php` with no `.env` or env loader references
- no `.vscode`, `.devcontainer`, or other editor tooling

then the repository is likely not fully configured for local development yet.

## Recommended checks

```shell
# Strong signals for local dev setup
[ -d .ddev ] && echo "DDEV detected"
[ -f .ddev/config.yaml ] && echo "DDEV config.yaml found"
[ -f .lando.yml ] && echo "Lando detected"
[ -f docker-compose.yml ] && echo "Docker Compose detected"
[ -f .devcontainer/devcontainer.json ] && echo "Dev Container detected"

# Additional clues
[ -f .env ] && echo ".env found"
[ -f composer.json ] && echo "Composer project"
[ -f wp-config.php ] && echo "WordPress site"
```

## What to do if no local development setup is detected

No local development environment was detected in this folder. If you have a different setup that is not covered here, let us know and we can try to adapt the guidance.

If you do not have a local setup yet, we recommend using DDEV.

- Create a DDEV project for the current folder.
- Add a `.env` file or env loader to keep settings portable.
- Run `composer install` if `composer.json` exists.
- For WordPress, make sure `wp-config.php` supports env vars and local database fallbacks.

Learn more in the fortrabbit local development docs:
https://docs.fortrabbit.com/integrations/local-development/intro

This file is meant to help detect existing local development configuration, not to replace a full setup guide.
