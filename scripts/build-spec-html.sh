#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

in_dir="docs/spec"
out_dir="docs/spec/html"

mkdir -p "$out_dir"

mapfile -t org_files < <(find "$in_dir" -type f -name '*.org' -print | LC_ALL=C sort)

for file in "${org_files[@]}"; do
  rel="${file#${in_dir}/}"
  out="${out_dir}/${rel%.org}.html"
  mkdir -p "$(dirname "$out")"

  input_abs="${repo_root}/${file}"
  output_abs="${repo_root}/${out}"

  emacs --batch -Q \
    --load "scripts/org-export.el" \
    --eval "(content-stager/export-org-to-html \"${input_abs}\" \"${output_abs}\")"
done
