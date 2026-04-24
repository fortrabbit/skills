# Detect which software is installed in the current folder

This reference is dedicated to identifying the application stack present in the current project folder. It is separate from `local-development.md`, which focuses on local dev tooling and configuration.

## Detection — ordered priority (first match wins)

Check signals in this exact order. Stop at the first match.

```
1. IF wp-config.php exists OR wp-content/ directory exists
   → WordPress detected → load wordpress.md

2. ELSE IF composer.json contains "craftcms/cms" OR bin/craft file exists
   → Craft CMS detected → load craft-cms.md

3. ELSE IF composer.json contains "statamic/cms"
   → Statamic detected → load statamic.md

4. ELSE IF composer.json contains "getkirby/cms" OR site/plugins/ directory exists
   → Kirby detected → load kirby-cms.md

5. ELSE IF composer.json contains "laravel/framework" OR artisan file exists at project root
   → Laravel detected → load deploy.md

6. ELSE IF composer.json exists (but none of the above matched)
   → Generic PHP project detected → load deploy.md

7. ELSE (no signals found)
   → Ask: "I couldn't detect a PHP project here. What are you using?
       - WordPress
       - Craft CMS
       - Kirby
       - Statamic
       - Laravel
       - Other PHP"
     Load the matching guide based on the answer.
```

## Shell check

Use this script to gather signals:

```shell
if [ -f composer.json ]; then
  echo "PHP project detected"
  grep -q 'craftcms/cms' composer.json && echo "Craft CMS detected"
  grep -q 'statamic/cms' composer.json && echo "Statamic detected"
  grep -q 'getkirby/cms' composer.json && echo "Kirby CMS detected"
  grep -q 'laravel/framework' composer.json && echo "Laravel detected"
fi
[ -f wp-config.php ] && echo "WordPress detected"
[ -d wp-content ] && echo "WordPress wp-content found"
[ -f artisan ] && echo "Laravel artisan found"
[ -f bin/craft ] && echo "Craft CMS bin/craft found"
```

Apply the priority order above to the results — do not use the first matching line from the shell output, use the first matching rule from the ordered list.
