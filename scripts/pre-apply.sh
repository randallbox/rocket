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
module_source="${recipe_dir}/modules/custom/rocket_branding"
module_target="${root}/modules/custom/rocket_branding"

if [[ ! -d "${theme_source}" ]]; then
  echo "Could not find bundled Rocket theme at ${theme_source}." >&2
  exit 1
fi

if [[ ! -d "${module_source}" ]]; then
  echo "Could not find bundled Rocket Branding module at ${module_source}." >&2
  exit 1
fi

mkdir -p "${theme_target}"
cp -R "${theme_source}/." "${theme_target}/"

mkdir -p "${module_target}"
cp -R "${module_source}/." "${module_target}/"

echo "Installed Rocket theme to ${theme_target}."
echo "Installed Rocket Branding module to ${module_target}."
