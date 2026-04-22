# SSH key setup

SSH access to fortrabbit requires a key pair: a private key on your machine and the matching public key registered in the fortrabbit dashboard.

## Check for existing SSH keys

```shell
find ~/.ssh -name "*.pub"
```

If you see files like `id_ed25519.pub` or `id_rsa.pub`, you already have a key pair — skip to [Add your key to fortrabbit](#add-your-key-to-fortrabbit).

If the directory is empty or missing, generate a new key.

## Generate a new SSH key pair

```shell
ssh-keygen -t ed25519 -C me@fortrabbit
```

Accept the default path (`~/.ssh/id_ed25519`) and optionally set a passphrase. This creates two files:

- `~/.ssh/id_ed25519` — private key (never share this)
- `~/.ssh/id_ed25519.pub` — public key (upload this to fortrabbit)

## Add your key to fortrabbit

Ask the user: **Have you already added this SSH key to your fortrabbit account?**

If not, copy the public key to the clipboard:

```shell
# macOS
pbcopy < ~/.ssh/id_ed25519.pub

# Linux
xclip -i < ~/.ssh/id_ed25519.pub
```

Then open the fortrabbit dashboard and add a new SSH key
https://dash.fortrabbit.com/new/ssh-key

> Only paste the **public** key (`.pub` file). Never share your private key.

Personal keys automatically apply to all environments where you have developer access.

## Test the connection

```shell
ssh APP_ENV_ID@ssh.REGION.frbit.app echo "ok"
```

If this returns `ok`, the key is working. If it fails, see the Troubleshooting section below.

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
