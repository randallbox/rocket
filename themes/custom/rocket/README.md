# Rocket theme

[Bootstrap 5](https://www.drupal.org/project/bootstrap5) subtheme.

## Page template variables.

The theme exposes additional variables to `page.html.twig` and
`page--front.html.twig` from Rocket theme settings:

- `rocket_inverse_logo`: Rendered inverse logo image, when configured. Includes
  Bootstrap's `img-fluid` class so it contracts to the width of its container.
- `rocket_inverse_logo_url`: URL string for the configured inverse logo.
- `rocket_inverse_logo_path`: Stored path/URI for the configured inverse logo.
- `rocket_attribution_text`: Rendered attribution text using the selected
  Drupal text format, so allowed HTML is processed safely.
- `rocket_attribution_text_raw`: Raw attribution text value before text-format
  processing.
- `rocket_attribution_text_format`: Text format ID used for attribution text.

## Development.

### CSS compilation.

Prerequisites: install [sass](https://sass-lang.com/install).

To compile, run from subtheme directory: `sass scss/style.scss css/style.css && sass scss/ck5style.scss css/ck5style.css`
