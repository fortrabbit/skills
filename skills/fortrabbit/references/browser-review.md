# Browser review: test your changes

After making changes to your fortrabbit environment, review them in a browser using the test domain.

## Test domain URL

```text
https://APP_ENV_ID.REGION.frbit.app
```

Always include the region segment.  
Example: `https://en-0rk7ap.eu-w1a.frbit.app`.  
The TLD is `frbit.app`. Do not use `frb.io` or `frb.app` — both are wrong.

## Pre-test with curl

Before asking the user to open a browser, run a quick HTTP check:

```shell
curl -o /dev/null -s -w "%{http_code}" https://APP_ENV_ID.REGION.frbit.app
```

| Status          | Action                                                                                       |
| --------------- | -------------------------------------------------------------------------------------------- |
| `200`           | Site is up — ask user to review in browser                                                   |
| `301` / `302`   | Redirect — follow with `curl -L` and check the final destination                             |
| `404`           | Page not found — check deployment logs, verify the app is deployed and the domain is correct |
| `500` / `502` / | Server error — load deployment logs immediately and investigate                              |
| timeout         | Connection failed — check SSH connection and whether deployment completed                    |

For a more detailed response (headers, redirect chain):

```shell
curl -I -L https://APP_ENV_ID.REGION.frbit.app
```

## When to use test domain

Use after any code deployment, SSH exec, content sync, or database operation.

## Troubleshooting

If the curl check fails or returns an error code, load [http-error-troubleshooting.md](http-error-troubleshooting.md) and follow the steps for the specific status code.

Additional checks:

1. Check the deployment log (**Dashboard → Environment → Deployments**) for Composer errors or failing post-deploy commands, if deployed via Git
2. Confirm SSH access is working: `ssh APP_ENV_ID@ssh.REGION.frbit.app 'php --version'`

For more details, see the [fortrabbit test domain documentation](https://docs.fortrabbit.com/platform/dns/test-domain).