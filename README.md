# Rocket

Rocket is a reusable Drupal starter recipe.

## What It Includes

- A starter layer intended for a fresh Drupal Standard installation.
- The Rocket Bootstrap 5 subtheme as the default theme.
- Admin Toolbar, Pathauto, Slick/Slick Views, Focal Point, Image Effects, Views Bootstrap, Turnstile, Metatag, Schema Metatag, XML Sitemap, Redirect, Webform, and SendGrid Integration.
- Reusable starter configuration, including Pathauto patterns, the `home_banner` content type, Home banner desktop/mobile image styles, and the Home banner responsive image style.
- A Home banner View configured with Slick, a dedicated Slick optionset, and a block placed in the Rocket `banner` region on the front page.
- Default Home banner content with placeholder images.
- A reusable Contact webform and a `/get-in-touch` Basic page with a Layout Builder section containing the contact form.
- Rocket theme templates and SCSS tweaks, including the banner region and four footer regions.
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

Leave `randallbox/rocket` installed in Composer after applying the recipe so its Drupal package dependencies remain part of the site.

## Apply

Install the new Drupal site with the Standard profile first, then apply Rocket.

From this legacy Drupal root:

```sh
./recipes/rocket/scripts/pre-apply.sh
php core/scripts/drupal recipe recipes/rocket
./recipes/rocket/scripts/post-apply.sh
```

For a recommended-project layout, run the pre-apply script from the project root or web root first, then run the recipe command from the web root and point to wherever Composer placed the recipe.

The pre-apply script copies the bundled Rocket theme into place. This must happen before applying the recipe because Drupal needs to discover it before it can install it.

## Scripts

The pre-apply script performs the theme setup:

- copies the bundled Rocket theme to `themes/custom/rocket`
- includes the `banner` region, page templates, compiled CSS, and SCSS source files

The post-apply script performs the requested library steps:

- runs `drush webform:libraries:download`
- downloads the Slick library zip from `kenwheeler/slick`
- places the Slick library at `libraries/slick`

After applying Rocket, create site-specific keys for Turnstile and SendGrid and connect the modules to those keys.
