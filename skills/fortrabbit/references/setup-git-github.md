# Setting up Git and GitHub for fortrabbit deployment

## Prerequisites

Before deploying via Git, your project must be a Git repository connected to GitHub, and the fortrabbit GitHub App must be installed and connected to your repository.

## Install GitHub CLI (gh)

To automate GitHub tasks, install the GitHub CLI:

**macOS (with Homebrew):**

```bash
brew install gh
```

**Other platforms:** Follow the installation instructions at [cli.github.com](https://cli.github.com).

After installation, authenticate with GitHub:

```bash
gh auth login
```

Follow the prompts to sign in.

## Initialize Git repository

If the current directory is not a Git repository:

```bash
git init
git add .
git commit -m "Initial commit"
```

## Create GitHub repository

```bash
gh repo create my-project --public --source=. --remote=origin --push
```

Use `--private` for a private repo. To create manually: go to GitHub.com → New repository, then:

```bash
git remote add origin https://github.com/username/repo.git
git branch -M main
git push -u origin main
```

## Install fortrabbit GitHub App

The fortrabbit GitHub App must be installed on your GitHub account to enable automatic deployments.

### Install the fortrabbit GitHub App

Visit [github.com/apps/fortrabbit](https://github.com/apps/fortrabbit) and click Install. Select the account or organization and grant access to the repositories you want to deploy.

To check if it is already installed, open your GitHub settings:

```bash
open https://github.com/settings/installations   # macOS
xdg-open https://github.com/settings/installations  # Linux
```

Look for **fortrabbit** in the list. See also [local-development.md](local-development.md) for the full check procedure.

## Connect fortrabbit account to GitHub

Link your fortrabbit account to GitHub at [dash.fortrabbit.com/you/settings#login-options](https://dash.fortrabbit.com/you/settings#login-options) under "Login Options".

## Connect app to Git repository

Connect your app environment to the repository at [dash.fortrabbit.com/connect/app-git-repo](https://dash.fortrabbit.com/connect/app-git-repo). Map the `main` branch to your environment. Pushes to that branch will trigger deployments automatically.

## Verify setup

Once connected, trigger your first deployment — see [deploy.md](deploy.md).
