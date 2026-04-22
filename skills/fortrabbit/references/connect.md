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

## Step 5 — Test the SSH connection

```shell
# Replace APP_ENV_ID and REGION with your values
ssh APP_ENV_ID@ssh.REGION.frbit.app echo "Connection OK"
```

A successful connection prints the fortrabbit welcome banner followed by "Connection OK". If the connection fails, load [ssh-key-setup.md](ssh-key-setup.md) and follow the setup and troubleshooting steps there.

---

## Step 6 — Continue to software setup

**If the software stack is already known** (detected earlier via `start.md` or visible in the project folder), load the matching guide directly:

- WordPress → `wordpress.md`
- Craft CMS → `craft-cms.md`
- Statamic → `statamic.md`
- Kirby → `kirby-cms.md`
- Laravel → `deploy.md`
- Generic PHP → `deploy.md`

**If no software was detected yet**, run detection now — see [software-detection.md](software-detection.md).

**If the folder is empty** (no project exists yet), ask the user which software they want to use and load the matching guide from the list above. The guide will walk through local installation first.
