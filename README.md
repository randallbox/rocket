# Rocket

Rocket is a reusable Drupal starter recipe.

## What It Includes

- A starter layer intended for a fresh Drupal Standard installation.
- Bootstrap 5 as the default theme.
- Admin Toolbar, Pathauto, Slick/Slick Views, Focal Point, Image Effects, Views Bootstrap, Turnstile, Metatag, Schema Metatag, XML Sitemap, Redirect, Webform, and SendGrid Integration.
- Reusable starter configuration, including Pathauto patterns, the `home_banner` content type, and the related responsive image/image style config.
- SCSS tweaks.
- Safe defaults for CAPTCHA, Mail System, and Turnstile.

Configure new Turnstile and SendGrid keys on each site after applying the recipe.

## Composer

For a local path repository:

```sh
composer config repositories.rocket path recipes/rocket
composer require randallbox/rocket:dev-main
```

For the GitHub repository:

```sh
composer config repositories.rocket vcs git@github.com:randallbox/rocket.git
composer require randallbox/rocket:dev-main
```

Once the repository has a tagged release, replace `dev-main` with the tag constraint, such as `^1.0`.

## Apply

Install the new Drupal site with the Standard profile first, then apply Rocket.

From this legacy Drupal root:

```sh
php core/scripts/drupal recipe recipes/rocket
bash recipes/rocket/scripts/post-apply.sh
```

For a recommended-project layout, run the recipe command from the web root and point to wherever Composer placed the recipe.

## Post-Apply Work

Drupal recipes do not run arbitrary Drush commands or download third-party zip assets by themselves. The post-apply script performs the requested follow-up steps:

- runs `drush webform:libraries:download`
- downloads the Slick library zip from `kenwheeler/slick`
- places the Slick library at `libraries/slick`

After applying Rocket, create site-specific keys for Turnstile and SendGrid and connect the modules to those keys.
