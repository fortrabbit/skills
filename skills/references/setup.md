# Setup: Connecting to fortrabbit via SSH

## Prerequisites

You need an SSH key pair registered with your fortrabbit account. If you haven't done this yet:

1. Check if you have an existing key: `ls ~/.ssh/id_*.pub`
2. If not, generate one: `ssh-keygen -t ed25519 -C "your@email.com"`
3. Add the public key in the fortrabbit dashboard under: **Account → SSH keys**
   - Dashboard URL: https://dash.fortrabbit.com/you/ssh-keys

## Test the connection

```shell
# Replace APP_ENV_ID and REGION with your values
ssh APP_ENV_ID@ssh.REGION.frbit.app echo "Connection OK"
```

A successful connection prints the fortrabbit welcome banner followed by "Connection OK". If you see a permission denied error, the SSH key is not registered or not being sent.

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

## Troubleshooting

**Permission denied (publickey)**

- Confirm your public key is in the fortrabbit dashboard.
- Run `ssh-add ~/.ssh/id_ed25519` to make sure the key is loaded.
- Try `ssh -v APP_ENV_ID@ssh.REGION.frbit.app` for verbose output.

**Connection timeout**

- Verify the environment ID and region are correct.
- Check that port 22 is not blocked by a firewall.

**Multiple SSH keys**

If you have multiple keys, add an entry to `~/.ssh/config`:

```text
Host ssh.*.frbit.app
  IdentityFile ~/.ssh/your_fortrabbit_key
```
