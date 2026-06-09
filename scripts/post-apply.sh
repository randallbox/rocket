#!/usr/bin/env bash
set -euo pipefail

root="${1:-$(pwd)}"

if [[ ! -d "${root}/core" && -d "${root}/web/core" ]]; then
  root="${root}/web"
fi

if [[ ! -d "${root}/core" ]]; then
  echo "Could not find a Drupal root. Run from the Drupal root or pass it as the first argument." >&2
  exit 1
fi

project_root="${root}"
if [[ -d "${root}/../vendor" && ! -d "${root}/vendor" ]]; then
  project_root="$(cd "${root}/.." && pwd)"
fi

drush="${project_root}/vendor/bin/drush"
if [[ ! -x "${drush}" ]]; then
  drush="${root}/vendor/bin/drush"
fi

if [[ ! -x "${drush}" ]]; then
  echo "Could not find Drush. Make sure drush/drush has been installed with Composer." >&2
  exit 1
fi

for command in curl unzip; do
  if ! command -v "${command}" >/dev/null 2>&1; then
    echo "Missing required command: ${command}" >&2
    exit 1
  fi
done

"${drush}" --root="${root}" webform:libraries:download --yes

libraries_dir="${root}/libraries"
slick_dir="${libraries_dir}/slick"
slick_url="https://github.com/kenwheeler/slick/archive/refs/heads/master.zip"

mkdir -p "${libraries_dir}"

if [[ -d "${slick_dir}" ]]; then
  echo "Slick library already exists at ${slick_dir}; leaving it in place."
  exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

curl -L "${slick_url}" -o "${tmp_dir}/slick.zip"
unzip -q "${tmp_dir}/slick.zip" -d "${tmp_dir}"
mv "${tmp_dir}/slick-master" "${slick_dir}"

echo "Installed Slick library to ${slick_dir}."
