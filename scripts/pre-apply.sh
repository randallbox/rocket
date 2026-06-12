#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
recipe_dir="$(cd "${script_dir}/.." && pwd)"
root="${1:-$(pwd)}"

if [[ ! -d "${root}/core" && -d "${root}/web/core" ]]; then
  root="${root}/web"
fi

if [[ ! -d "${root}/core" ]]; then
  echo "Could not find a Drupal root. Run from the Drupal root or pass it as the first argument." >&2
  exit 1
fi

theme_source="${recipe_dir}/themes/custom/rocket"
theme_target="${root}/themes/custom/rocket"
bootstrap5_optional_config="${root}/themes/contrib/bootstrap5/config/optional"

if [[ ! -d "${theme_source}" ]]; then
  echo "Could not find bundled Rocket theme at ${theme_source}." >&2
  exit 1
fi

if [[ -d "${bootstrap5_optional_config}" ]]; then
  while IFS= read -r -d '' file; do
    sed -i 's/^  depth: 0$/  depth: 8/' "${file}"
  done < <(find "${bootstrap5_optional_config}" -name 'block.block.bootstrap5_*.yml' -print0)
fi

mkdir -p "${theme_target}"
cp -R "${theme_source}/." "${theme_target}/"

echo "Installed Rocket theme to ${theme_target}."
