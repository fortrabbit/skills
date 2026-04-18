# Deploying to fortrabbit

## How deployment works

fortrabbit deploys code via Git. The recommended workflow:

1. You push code to GitHub (your Git provider)
2. The fortrabbit GitHub app detects the push
3. A deployment is triggered automatically
4. The build pipeline runs (Composer install, build commands)
5. Post-deploy commands run (artisan migrate, cache:clear, etc.)

**Git is one-way:** you can only push code up. Never pull from the fortrabbit remote into your local repo.

## Trigger deployment via git push

```shell
# The normal workflow — push to your GitHub remote
git push origin main
```

If your GitHub repo is connected to the fortrabbit app, this triggers a deployment automatically. Check the deployment status in the dashboard.

## Trigger deployment via deploy hook

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

## Common post-deploy commands by framework

These run automatically after each deployment if configured in the dashboard:

**Laravel:**
```bash
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

**Craft CMS:**
```bash
php craft project-config/apply
php craft clear-caches/all
```

**Statamic:**
```bash
php artisan statamic:stache:warm
```

Configure these in the dashboard under:
**Dashboard → Environment → Deployment → Post deploy commands**

## Troubleshooting a failed deployment

1. Check the deployment log in the dashboard for the error message.
2. The most common failures are Composer errors or failing post-deploy commands.
3. Post-deploy command failures mean files were already deployed but the command failed — the app may be running new code without the migration applied.
4. If Composer fails: check `composer.json` for syntax errors or version conflicts.
