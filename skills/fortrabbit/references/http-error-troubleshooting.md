# HTTP error troubleshooting

Reference for diagnosing HTTP errors returned by a fortrabbit app. In most cases the problem is in the application code or configuration, not the platform.

---

## 404 — Not Found

**Meaning:** Server is reachable but nothing is at that URL.

Common causes:

- No code deployed yet — verify files are present via SSH: `ssh APP_ENV_ID@ssh.REGION.frbit.app 'ls htdocs/'`
- Wrong root path configured — `htdocs` is the default; check the dashboard if a custom root is set
- Missing `.htaccess` — hidden files are sometimes skipped by SFTP drag-and-drop; verify with `ssh APP_ENV_ID@ssh.REGION.frbit.app 'ls -la htdocs/'`
- New environment not ready yet — DNS and environment initialization can take a few minutes

---

## 500 — Internal Server Error

**Meaning:** The app reached the server but PHP exited with an error.

Steps:

1. **Check the logs** — Dashboard → Environment → Logs. The PHP error will usually be there.
2. **Review recent changes** — 500s commonly appear after code pushes, config changes, or Composer updates.
3. **Check `.htaccess`** — malformed rewrite rules are a frequent culprit.
4. **Reproduce locally** — if it fails locally too, the issue is in the code, not the platform.

```shell
# Tail logs via SSH (Laravel example — adjust path for your framework)
ssh APP_ENV_ID@ssh.REGION.frbit.app 'tail -n 50 storage/logs/laravel.log'

# Craft CMS
ssh APP_ENV_ID@ssh.REGION.frbit.app 'tail -n 50 storage/logs/web.log'

# Generic PHP error log
ssh APP_ENV_ID@ssh.REGION.frbit.app 'tail -n 50 logs/php_error.log'
```

---

## 503 — Service Unavailable

**Meaning:** PHP-FPM has too much to do and cannot accept new requests. Often occurs without any code change.

Common causes:

- **Buggy PHP code** — a WordPress plugin, Craft plugin, or custom code crashing the PHP process
- **Memory limit exceeded** — check the dashboard for swap usage; more than 10–30 MB of swap is a strong signal
- **Slow endpoints backing up** — if some requests are slow, new connections queue up until PHP-FPM is exhausted
- **Apache error `AH1067: Failed to read FastCGI header`** — the PHP process died mid-response

Steps:

1. Check logs (Dashboard → Environment → Logs) — 503s often produce no PHP log entries, but worth checking.
2. Disable plugins or custom code one by one to isolate the cause.
3. Check swap usage in the dashboard — consider upgrading the PHP plan if memory is the bottleneck.
4. Restart the environment from the dashboard as a temporary workaround (problem will recur if root cause is not fixed).

---

## 504 — Gateway Timeout

**Meaning:** Requests are taking too long to complete. PHP-FPM responds eventually but too slowly — or not at all.

Common causes:

- **Slow database queries** — the most common cause; profile with the dashboard's slow query log
- **Too many database queries** — common in Craft CMS or WordPress with many plugins
- **Image transformations** — ImageMagick jobs queuing up after bulk content uploads
- **External API calls blocking** — slow or unresponsive third-party services
- **Bots and scrapers** — uncached URL variants overwhelming the app
- **Infinite loops** in templates or application code

Steps:

1. Check PHP response times in the dashboard — target is ≤ 200 ms; anything higher needs investigation.
2. Check swap usage — high swap points to memory pressure.
3. Look for slow endpoints — disable plugins, themes, or custom code to isolate.
4. Check for bot traffic patterns in the access log.

---

## Log access reference

| Framework   | Log path                                       |
| ----------- | ---------------------------------------------- |
| Laravel     | `storage/logs/laravel.log`                     |
| Craft CMS   | `storage/logs/web.log`                         |
| Statamic    | `storage/logs/laravel.log`                     |
| WordPress   | Enable `WP_DEBUG_LOG` → `wp-content/debug.log` |
| Generic PHP | Dashboard → Environment → Logs                 |

Access via SSH:

```shell
ssh APP_ENV_ID@ssh.REGION.frbit.app 'tail -n 100 PATH_TO_LOG'
```

Or stream live:

```shell
ssh APP_ENV_ID@ssh.REGION.frbit.app 'tail -f PATH_TO_LOG'
```

Full log documentation: [docs.fortrabbit.com/platform/settings/logs](https://docs.fortrabbit.com/platform/settings/logs)
Check [status.fortrabbit.com](https://status.fortrabbit.com) — platform incidents are rare but do happen.
