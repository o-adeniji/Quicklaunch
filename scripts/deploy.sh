#!/usr/bin/env bash
set -euo pipefail

ARTIFACT="${1:-dist/quicklaunch-1.0.0.tar.gz}"
WEB_ROOT="/var/www/html"

if [ ! -f "$ARTIFACT" ]; then
  echo "Deployment failed: $ARTIFACT does not exist."
  exit 1
fi

echo "Deploying $ARTIFACT to Nginx..."

sudo tar -xzf "$ARTIFACT" -C "$WEB_ROOT"
sudo nginx -t
sudo systemctl reload nginx

curl -fsS http://localhost | grep -q "QuickLaunch"

echo "Deployment successful: http://localhost"#!/usr/bin/env bash
set -euo pipefail

ARTIFACT="${1:-dist/quicklaunch-1.0.0.tar.gz}"
WEB_ROOT="/var/www/html"

if [ ! -f "$ARTIFACT" ]; then
  echo "Deployment failed: $ARTIFACT does not exist."
  exit 1
fi

echo "Deploying $ARTIFACT to Nginx..."

sudo tar -xzf "$ARTIFACT" -C "$WEB_ROOT"
sudo nginx -t
sudo systemctl reload nginx

curl -fsS http://localhost | grep -q "QuickLaunch"

echo "Deployment successful: http://localhost"
