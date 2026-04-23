# Browser review: test your changes

After making changes to your fortrabbit environment, review them in a browser using the test domain.

## Test domain URL

Your fortrabbit app has a test domain you can use to review changes before they go live:

```text
https://APP_ENV_ID.REGION.frbit.app
```

## When to use test domain

Use after any code deployment, SSH exec, content sync, or database operation.

## Troubleshooting

If changes are not visible: check deployment logs in the dashboard, allow a few minutes, clear browser cache, verify the environment ID in the URL.

For more details, see the [fortrabbit test domain documentation](https://docs.fortrabbit.com/platform/dns/test-domain).
