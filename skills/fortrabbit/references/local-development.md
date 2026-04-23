# Detect local development setup in the current folder

This reference helps identify whether the current project already has a local development environment configured.

## Recommended checks

Run these to detect container-based and native local setups:

```shell
# Strong signals for local dev setup based on containers
[ -d .ddev ] && echo "DDEV detected"
[ -f .ddev/config.yaml ] && echo "DDEV config.yaml found"
[ -f .lando.yml ] && echo "Lando detected"
[ -f docker-compose.yml ] && echo "Docker Compose detected"
[ -f .devcontainer/devcontainer.json ] && echo "Dev Container detected"

# Native stack
php --version 2>/dev/null && echo "PHP available"
mysqladmin ping 2>/dev/null && echo "MySQL server running"
[ -d ~/.config/valet ] && echo "Laravel Valet config found"
[ -d ~/.config/herd ] && echo "Laravel Herd config found"
[ -d /Applications/MAMP ] && echo "MAMP found"

# Additional clues
[ -f .env ] && echo ".env found"
[ -f composer.json ] && echo "Composer project"
[ -f wp-config.php ] && echo "WordPress site"
```

## Check for Git and GitHub

```shell
git rev-parse --git-dir 2>/dev/null && echo "git repo" || echo "not a git repo"
git remote -v 2>/dev/null
```

Note whether:

- The folder is a Git repository
- A remote named `origin` points to `github.com`

## Check for the GitHub CLI (gh)

```shell
which gh 2>/dev/null && gh --version || echo "gh not found"
gh auth status 2>/dev/null || echo "gh not authenticated"
```

Note whether:

- `gh` is installed and on the PATH
- The user is authenticated (`gh auth status` exits 0 and shows a logged-in account)

If `gh` is missing, it can be installed via Homebrew on macOS: `brew install gh`, or from [cli.github.com](https://cli.github.com).

## Check for the fortrabbit GitHub App (only when asked)

Don't do this when following general flows. Only do this when asked by the user and the user has git installed and the gh client.

The fortrabbit GitHub App enables GitHub-triggered deployments. It can be installed on a personal account or on any GitHub organization.

If `gh` is installed and authenticated, determine the accounts to check:

```shell
# Get the authenticated GitHub username
gh api /user --jq .login

# List organizations the user belongs to
gh api /user/orgs --jq '.[].login'
```

The GitHub API does not expose app installation status to standard user tokens, so the check must be done via the browser. Open the installations settings page directly:

```shell
gh browse --no-browser  # prints repo URL for context
# Then navigate to:
# https://github.com/settings/installations
```

Or open it immediately:

```shell
open https://github.com/settings/installations   # macOS
xdg-open https://github.com/settings/installations  # Linux
```

Look for **fortrabbit** in the list of installed GitHub Apps. It may appear under the personal account or under one of the organizations listed above.

If it is not installed, suggest installing it:

> "The fortrabbit GitHub App is not installed. You can install it at [github.com/apps/fortrabbit](https://github.com/apps/fortrabbit). Choose the account (personal or organization) that owns the repositories you want to deploy from. After installation you can select which repositories the app may access."

## What to do if no local development setup is detected

No local development environment was detected in this folder.

**Ask the user about their preference before suggesting a setup.** A good prompt:

> "No local development environment was found in this project. How would you like to set one up? Options depend on what's available on your machine:
>
> - **Native PHP + MySQL** (if PHP and MySQL are already running locally — lighter weight, no Docker required)
> - **DDEV** (Docker-based, cross-platform, recommended for teams)
> - **Laravel Valet / Herd** (macOS only, zero-config for Laravel and other PHP apps)
> - **Lando** (Docker-based, flexible)
> - **Skip for now** and work with the remote environment only"

### If native PHP + MySQL are present

When PHP is available and a local MySQL server is running, offer the native stack as a first-class option — it requires no additional tooling:

1. Create a local database: `mysql -u root -e "CREATE DATABASE myapp;"`
2. Copy `.env.example` to `.env` and set `DB_HOST=127.0.0.1`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`.
3. Run `composer install`.
4. Run framework-specific setup (e.g. `php artisan key:generate` for Laravel, `php craft setup` for Craft).
5. Use the built-in PHP server (`php -S localhost:8000 -t public`) or configure a virtual host in Valet/Herd/MAMP.

### If no native stack is found — ask about intent first

Before recommending a setup, ask the user:

> "Are you setting this up for a real project (team, client, ongoing work), or just testing and exploring?"

**Testing / exploring:**

For file-based CMS projects (Kirby, Statamic) that don't require a database, the built-in PHP server is often sufficient — no Docker needed:

```bash
php -S localhost:8000 -t public
```

For Kirby, the document root is typically the project root (not `public/`):

```bash
php -S localhost:8000
```

This starts immediately with no configuration. Suggest this first for low-stakes use.

**Serious / ongoing project:**

Recommend DDEV for projects that need a database (WordPress, Craft, Laravel), team consistency, or environment parity with fortrabbit:

- Create a DDEV project: `ddev config` then `ddev start`
- Add a `.env` file or env loader to keep settings portable
- Run `composer install` if `composer.json` exists
- For WordPress, make sure `wp-config.php` supports env vars and local database fallbacks

Learn more in the [fortrabbit local development docs](https://docs.fortrabbit.com/integrations/local-development/intro).
