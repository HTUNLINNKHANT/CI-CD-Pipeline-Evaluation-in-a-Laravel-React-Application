#!/usr/bin/env bash
set -euo pipefail

if [[ -f "composer.json" ]]; then
  composer install --no-interaction --prefer-dist --no-progress
fi

if [[ -f "frontend/package.json" ]]; then
  (cd frontend && npm ci)
elif [[ -f "package.json" ]]; then
  npm ci
fi
