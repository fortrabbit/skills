# Connect: Start using fortrabbit

## Step 1 — Do you have a fortrabbit account?

Ask the user:

> "Do you have a fortrabbit account?"

- **No account yet:** Direct them to sign up at [dash.fortrabbit.com/signup](https://dash.fortrabbit.com/signup) — there is a free trial, no credit card required to start. Once signed up, continue to Step 2.
- **Yes:** Continue to Step 2.

---

## Step 2 — Do you have an app?

Ask the user:

> "Do you already have an app on fortrabbit?"

- **No app yet:** Direct them to create one at [dash.fortrabbit.com/new/app](https://dash.fortrabbit.com/new/app). Once the app is created, the dashboard shows the environment ID and region needed in the next step.
- **Yes:** Continue to Step 3.

---

## Step 3 — Find your app environment ID and region

Both values are shown in the fortrabbit dashboard on the environment page, next to the SSH access details.

- The app environment ID is a short random string, for example: `en-wjl0ai`
- The region is a location code, for example: `eu-w1a` or `us-e1a`

Full SSH address: `en-xxxxxx@ssh.xxxxxx.frbit.app`

---

## Step 4 — Save the config locally

Create a `.fortrabbit` file in your project root, if not already present:

```
app-env-id=en-xxxxxx
region=eu-w1a
```

This file contains no secrets and can safely be committed to Git.

---

## Step 5 — SSH key setup

Ask the user to visit **you/ssh-keys** in the fortrabbit dashboard https://dash.fortrabbit.com/you/ssh-keys to check whether an SSH key is already registered. If one is present, skip to the next step. If not, follow [ssh-key-setup.md](ssh-key-setup.md) to generate and register a key.

---

## Step 6 — Test the connection

```shell
# Replace APP_ENV_ID and REGION with your values
ssh APP_ENV_ID@ssh.REGION.frbit.app echo "Connection OK"
```

A successful connection prints the fortrabbit welcome banner followed by "Connection OK". If you see a permission denied error, the SSH key is not registered or not being sent — follow [ssh-key-setup.md](ssh-key-setup.md).

## Step 7 — Next steps

Ask the user how they want to proceed from here.

## Path A: Start from scratch

The user has no local project yet.

1. Ask which software they want to use:
   - WordPress
   - Craft CMS
   - Statamic
   - Kirby CMS
   - Laravel
   - Generic PHP
2. Load matching framework guide (`wordpress.md`, `craft-cms.md`, `statamic.md`, or `kirby-cms.md`).

## Path B: Continue with software specific guides

Load matching framework guide (`wordpress.md`, `craft-cms.md`, `statamic.md`, or `kirby-cms.md`).