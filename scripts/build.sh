#!/usr/bin/env bash
set -e

VERSION="${1:-1.0.0}"
ARTIFACT="quicklaunch-${VERSION}.tar.gz"

rm -rf dist
mkdir -p dist

tar -czf "dist/$ARTIFACT" -C src .

echo "Build completed: dist/$ARTIFACT"
