# Browser review: test your changes

After making changes to your fortrabbit environment, review them in a browser using the test domain.

## Test domain URL

Your fortrabbit app has a test domain you can use to review changes before they go live:

```
https://{{ environment }}.{{ region }}.frbit.app
```

Replace `{{ environment }}` with your environment ID (e.g., `en-wjl0ai`) and `{{ region }}` with your region (e.g., `eu-w1a`).

## When to use test domain

Use the test domain to review changes after:

- **SSH exec operations**: After running remote commands that modify the app
- **Content sync**: After uploading files, themes, or media
- **Code deployment**: After pushing code changes
- **Database operations**: After pushing or pulling database changes

## Troubleshooting

If the test domain doesn't show your changes:

- Wait a few minutes for deployment to complete
- Check the deployment logs in the dashboard
- Clear browser cache or try incognito mode
- Verify the environment ID in the URL is correct

For more details, see the fortrabbit test domain documentation:
https://docs.fortrabbit.com/platform/dns/test-domain