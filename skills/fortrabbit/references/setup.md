# Setup: Connecting to fortrabbit via SSH

## Step 0 — Do you have a fortrabbit app?

Before anything else, ask the user:

> "Do you already have an app on fortrabbit?"

**If no:** Ask whether they have a fortrabbit account.

- **No account yet:** Direct them to sign up at [dash.fortrabbit.com/signup](https://dash.fortrabbit.com/signup) — there is a free trial, no credit card required to start. Once signed up, they can create an App from the dashboard. Walk them through that before continuing.
- **Account but no app:** Direct them to the dashboard to create a new App: [dash.fortrabbit.com/new/app](https://dash.fortrabbit.com/new/app) — once the app is created, the dashboard shows the environment ID and region needed below.

**If yes:** Continue with the prerequisites below.

---

## Prerequisites

You need an SSH key pair, locally and the public part registered with your fortrabbit account. See [ssh-key-setup.md](ssh-key-setup.md).

## Test the connection

```shell
# Replace APP_ENV_ID and REGION with your values
ssh APP_ENV_ID@ssh.REGION.frbit.app echo "Connection OK"
```

A successful connection prints the fortrabbit welcome banner followed by "Connection OK". If you see a permission denied error, the SSH key is not registered or not being sent — follow [ssh-key-setup.md](ssh-key-setup.md).

## Finding your app environment ID and region

Both values are shown in the fortrabbit dashboard on the environment page, next to the SSH access details.

The app environment ID is a short random string, for example: `en-wjl0ai`

The region is a location code, for example: `eu-w1a` or `us-e1a`

Full SSH address: `en-xxxxxx@ssh.xxxxxx.frbit.app`

## Save the config locally

Create a `.fortrabbit` file in your project root:

```
app-env-id=en-xxxxxx
region=eu-w1a
```

This file contains no secrets and can safely be committed to Git.

If you use a deploy hook, store only the secret token in `.env`:

```
FORTRABBIT_DEPLOY_HOOK_SECRET=your-secret-token
```

Your `.env` should already be in `.gitignore`. If not:

```shell
echo ".env" >> .gitignore
```