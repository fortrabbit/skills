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

First, check what tooling is already available on the machine (the checks above will have revealed this). Then apply this decision tree:

```
IF DDEV is installed (ddev version succeeded)
  → Say: "DDEV is already installed. Run these two commands to start your local environment:
      ddev config
      ddev start"
  → Done. No further questions needed.

ELSE (DDEV not installed)
  → Ask: "Is this for an ongoing project (team, client, long-term work), or just testing and exploring?"

  IF testing/exploring:
    IF CMS is Kirby OR Statamic (file-based, no database needed)
      → Say: "For quick testing, you can use the built-in PHP server — no Docker required."
        For Statamic: php -S localhost:8000 -t public
        For Kirby:    php -S localhost:8000
    ELSE (WordPress, Craft CMS, Laravel — database required)
      → Say: "Even for testing, this project needs a database. The quickest option is DDEV:
          ddev config && ddev start
        It handles PHP and MySQL automatically."

  IF ongoing/team project:
    IF native PHP + MySQL are both available (php --version and mysqladmin ping both succeed)
      → Offer native stack first:
        Say: "PHP and MySQL are already running locally — you can use the native stack (no Docker needed):
          1. mysql -u root -e 'CREATE DATABASE myapp;'
          2. Copy .env.example to .env and set DB_HOST=127.0.0.1, DB_DATABASE, DB_USERNAME, DB_PASSWORD
          3. composer install
          4. [framework-specific setup command]
          5. php -S localhost:8000 -t public
        Or I can guide you through DDEV instead. Which do you prefer?"
    ELSE
      → Ask: "Which local setup would you prefer?
          1. DDEV (recommended — Docker-based, matches fortrabbit environment, works on all platforms)
          2. Laravel Herd or Valet (macOS only — zero-config for Laravel and PHP apps)
          3. Lando (Docker-based, flexible config)
          4. Docker Compose (manual setup)
        Enter a number."
      Guide setup based on the answer.

  IF user answers "skip for now"
    → Say: "No problem. You can work directly with the remote environment using /fortrabbit ssh commands. Run /fortrabbit ssh to get started."
```

Learn more in the [fortrabbit local development docs](https://docs.fortrabbit.com/integrations/local-development/intro).
