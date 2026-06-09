<?php

declare(strict_types=1);

namespace Drupal\rocket_branding\Plugin\Block;

use Drupal\Core\Block\Attribute\Block;
use Drupal\Core\Block\BlockBase;
use Drupal\Core\Cache\Cache;
use Drupal\Core\Extension\ThemeSettingsProvider;
use Drupal\Core\File\FileUrlGeneratorInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\Core\Url;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides a block that renders the Rocket brand logo.
 */
#[Block(
  id: 'brand_logo',
  admin_label: new TranslatableMarkup('Brand logo'),
  category: new TranslatableMarkup('Rocket')
)]
final class BrandLogoBlock extends BlockBase implements ContainerFactoryPluginInterface {

  /**
   * Creates a BrandLogoBlock instance.
   */
  public function __construct(
    array $configuration,
    $plugin_id,
    $plugin_definition,
    protected ThemeSettingsProvider $themeSettingsProvider,
    protected FileUrlGeneratorInterface $fileUrlGenerator,
  ) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition): static {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get(ThemeSettingsProvider::class),
      $container->get('file_url_generator'),
    );
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration(): array {
    return parent::defaultConfiguration() + [
      'inverse' => FALSE,
      'label_display' => '0',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function blockForm($form, FormStateInterface $form_state): array {
    $form['inverse'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Inverse'),
      '#description' => $this->t('Render the inverse logo instead of the primary logo.'),
      '#default_value' => (bool) $this->configuration['inverse'],
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function blockSubmit($form, FormStateInterface $form_state): void {
    $this->configuration['inverse'] = (bool) $form_state->getValue('inverse');
  }

  /**
   * {@inheritdoc}
   */
  public function build(): array {
    $logo = $this->configuration['inverse'] ? $this->inverseLogoUrl() : $this->primaryLogoUrl();
    $logo ??= $this->primaryLogoUrl();

    if (!$logo) {
      return [];
    }

    return [
      '#type' => 'link',
      '#title' => [
        '#theme' => 'image',
        '#uri' => $logo,
        '#alt' => $this->t('Home'),
        '#attributes' => [
          'fetchpriority' => 'high',
        ],
      ],
      '#url' => Url::fromRoute('<front>'),
      '#options' => [
        'html' => TRUE,
        'attributes' => [
          'class' => ['navbar-brand', 'site-logo', 'd-block'],
          'rel' => 'home',
          'title' => $this->t('Home'),
        ],
      ],
      '#cache' => [
        'tags' => $this->getCacheTags(),
      ],
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function getCacheTags(): array {
    return Cache::mergeTags(parent::getCacheTags(), [
      'config:rocket.settings',
      'config:system.theme.global',
      'config:core.extension',
    ]);
  }

  /**
   * Gets the configured primary logo URL.
   */
  protected function primaryLogoUrl(): ?string {
    $logo = $this->themeSettingsProvider->getSetting('logo.url', 'rocket');
    return is_string($logo) && $logo !== '' ? $logo : NULL;
  }

  /**
   * Gets the configured inverse logo URL.
   */
  protected function inverseLogoUrl(): ?string {
    $path = $this->themeSettingsProvider->getSetting('inverse_logo.path', 'rocket');

    if (!is_string($path) || $path === '') {
      return NULL;
    }

    return $this->fileUrlGenerator->generateString($path);
  }

}
