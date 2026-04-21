# Detect which software is installed in the current folder

This reference is dedicated to identifying the application stack present in the current project folder. It is separate from `local-development.md`, which focuses on local dev tooling and configuration.

## What to look for first

If the folder is empty or contains only generic files, tell the user to create a local installation of a supported CMS or PHP app first.

Suggested starter projects:

- Craft CMS
- WordPress
- Statamic
- Kirby CMS

If the folder is empty, instruct the user to add a project scaffold or clone a repo before proceeding.

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

## What to do if software is detected

Load the matching framework guide for deployment and configuration guidance:

- WordPress → `wordpress.md`
- Craft CMS → `craft-cms.md`
- Statamic → `statamic.md`
- Kirby CMS → `kirby-cms.md`

## What to do if you only see PHP code

If there is PHP code but no clear CMS files:

- Check `composer.json` for package names and dependencies.
- Search for `namespace`, `use`, or framework-specific files like `artisan`, `craft`, or `index.php`.
- Recommend the user choose a supported CMS if they want a known fortrabbit workflow.

## What to do if the folder is empty

If there is nothing installed yet, explain that the user should create or clone a project first.

- "This folder does not contain a supported CMS installation yet. Create a WordPress, Craft CMS, Statamic, or Kirby project locally first."
- "Once you have an installed application, rerun the detection steps to continue."