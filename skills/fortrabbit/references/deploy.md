# Deploying to fortrabbit

## Check Git state first

Before asking the user anything, run these two checks:

```shell
git rev-parse --git-dir 2>/dev/null && echo "repo=yes" || echo "repo=no"
git remote get-url origin 2>/dev/null && echo "remote=yes" || echo "remote=no"
```

Then route based on the result:

```
IF repo=yes AND remote=yes (Git is set up)
  → Show the command and ask for confirmation:
      git push origin [current-branch]
    Say: "Ready to deploy via git push — the fortrabbit GitHub App will trigger the deployment automatically."
    Ask: "Run this now?"
    IF yes      → run the git push command
    IF user wants rsync instead → Load sync.md

ELSE IF repo=no OR remote=no (Git is not set up or incomplete)
  → Say: "Git deployment isn't configured yet. How would you like to deploy?
      A) Set up Git now (connects GitHub → fortrabbit webhook, then push to deploy)
      B) Skip Git and use rsync (upload all files directly)"
  IF A → Load setup-git-github.md
  IF B → Load sync.md
```

## Trigger deployment via git push (recommended)

```shell
# The normal workflow — push to your GitHub remote
git push origin main
```

If your GitHub repo is connected to the fortrabbit app, this triggers a deployment automatically. Check the deployment status in the dashboard.

## Trigger deployment via deploy hook (alternate option)

If a deploy hook is configured, store only the secret token in `.env`:

```
FORTRABBIT_DEPLOY_HOOK_SECRET=your-secret-token
```

The full URL is constructed from the secret and the `app-env-id` from `.fortrabbit`:

```
https://api.fortrabbit.com/webhooks/environments/{app-env-id}/deploy/{secret}
```

Trigger it with:

```shell
curl -X POST \
  "https://api.fortrabbit.com/webhooks/environments/APP_ENV_ID/deploy/SECRET" \
  -H "User-Agent: fortrabbit"
```

A successful response looks like:
```json
{"data": {"publicId": "dp-abc123"}}
```

Find and configure deploy hooks in the dashboard:
**Dashboard → Environment → Deployment → Deploy hook**

Deploy hooks are useful for:
- CMS publish events (trigger deploy when content is published)
- Manual deploys without a git push
- Scheduled deployments from a cron job

> **Security:** The secret token grants anyone the ability to trigger a deployment. Store it only in `.env`, never in `.fortrabbit` or any committed file. Rotate it from the dashboard if compromised.

## Check deployment status

Deployment history and logs are visible in the dashboard under:
**Dashboard → Environment → Deployments**

## Post-deploy commands

Configure framework-specific commands (migrations, cache:clear) in the dashboard under **Deployment → Post deploy commands**. Use `/fortrabbit ssh` to run commands on the remote environment.

## Troubleshooting a failed deployment

1. Check the deployment log in the dashboard for the error message.
2. The most common failures are Composer errors or failing post-deploy commands.
3. Post-deploy command failures mean files were already deployed but the command failed — the app may be running new code without the migration applied.
4. If Composer fails: check `composer.json` for syntax errors or version conflicts.

After deploying, check your site at `https://APP_ENV_ID.REGION.frbit.app`. Use `/fortrabbit review` for a full response check with error diagnosis.
