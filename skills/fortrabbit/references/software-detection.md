# Detect which software is installed in the current folder

This reference is dedicated to identifying the application stack present in the current project folder. It is separate from `local-development.md`, which focuses on local dev tooling and configuration.

## What to look for first

If the folder is empty, tell the user to create or clone a project first (Craft CMS, WordPress, Statamic, or Kirby CMS).

## Detect installed software by file signatures

Look for these strong file signals:

- WordPress: `wp-config.php`, `wp-content/`, `wp-includes/`, `wp-admin/`
- Craft CMS: `craft`, `config/project/`, `config/app.php`, `composer.json` with `craftcms/cms`
- Statamic: `statamic/`, `composer.json` with `statamic/cms`, `site/`, `content/`
- Kirby CMS: `content/`, `site/`, `kirby/`, `composer.json` with `getkirby/cms`

For any PHP project, also look for `composer.json`.

## Look for PHP and WordPress clues

For PHP/WordPress projects, a stack detection scan may also inspect:

- `composer.json` and `vendor/` — Composer dependency install is expected
- `wp-config.php` or `wp-config-sample.php` — WordPress site root
- `.env` or `.env.example` — environment variable driven config
- `phpunit.xml` / `phpunit.xml.dist` — local test config

A rough equivalent shell check:

```shell
if [ -f composer.json ]; then
  echo "PHP project detected"
  grep -q 'craftcms/cms' composer.json && echo "Craft CMS detected"
  grep -q 'statamic/cms' composer.json && echo "Statamic detected"
  grep -q 'getkirby/cms' composer.json && echo "Kirby CMS detected"
fi
[ -f wp-config.php ] && echo "WordPress detected"
[ -d wp-content ] && echo "WordPress uploads directory found"
```

## Route by detection result

| Result | Action |
| --- | --- |
| CMS detected | Load matching guide: WordPress → `wordpress.md`, Craft CMS → `craft-cms.md`, Statamic → `statamic.md`, Kirby CMS → `kirby-cms.md` |
| PHP code, no clear CMS | Check `composer.json` for package names; look for `artisan`, `craft`, or other framework files; ask user which CMS they are using |
| Folder empty | Tell the user to create or clone a project first, then re-run detection |
