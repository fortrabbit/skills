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

Use the GitHub CLI to create a repository from the current directory:

```bash
gh repo create my-project --public --source=. --remote=origin --push
```

Replace `my-project` with your desired repository name. Use `--private` if you want a private repo.

This command:

- Creates the GitHub repository
- Adds it as the `origin` remote
- Pushes your initial commit

If you prefer to create manually or need more control:

1. Go to [GitHub.com](https://github.com) and sign in.
2. Click "New repository".
3. Give it a name, description, and choose public or private.
4. Do not initialize with README, .gitignore, or license (since you already have code).
5. Click "Create repository".
6. Copy the repository URL from the setup page (e.g., `https://github.com/username/repo.git`).

Then add the remote and push:

```bash
git remote add origin https://github.com/username/repo.git
git branch -M main
git push -u origin main
```

## Install fortrabbit GitHub App

The fortrabbit GitHub App must be installed on your GitHub account to enable automatic deployments.

### Check if the app is installed

You can check if the fortrabbit GitHub App is installed on your GitHub account:

```bash
gh api /user/installations | jq '.installations[] | select(.app_slug == "fortrabbit")'
```

If this returns data, the app is installed. If not, proceed to install it.

### Install the fortrabbit GitHub App

1. Visit [https://github.com/apps/fortrabbit](https://github.com/apps/fortrabbit)
2. Click "Install" or "Configure" if already installed.
3. Select the GitHub account or organization where you want to install the app.
4. Grant access to repositories (you can select specific repos or all repos).

Alternatively, use the GitHub CLI to open the installation page:

```bash
gh browse --repo=github.com/apps/fortrabbit
```

## Connect fortrabbit account to GitHub

Your fortrabbit account must be linked to your GitHub account.

1. Go to your fortrabbit account settings: [https://dash.fortrabbit.com/you/settings#login-options](https://dash.fortrabbit.com/you/settings#login-options)
2. Under "Login Options", ensure GitHub is connected. If not, click to connect your GitHub account.

## Connect app to Git repository

Finally, connect your fortrabbit app environment to the GitHub repository.

1. In the fortrabbit dashboard, go to [https://dash.fortrabbit.com/connect/app-git-repo](https://dash.fortrabbit.com/connect/app-git-repo)
2. Select your app environment and the GitHub repository you created.
3. Map branches to environments (e.g., `main` branch to production environment).

### Verify connection

Check the deployment settings for your environment: `https://dash.fortrabbit.com/environments/{app-env-id}/deployment`

You should see the connected repository and branch mappings.

Once connected, pushes to the mapped branches will trigger automatic deployments.

## Verify setup

Once connected, trigger your first deployment — see [deploy.md](deploy.md).
