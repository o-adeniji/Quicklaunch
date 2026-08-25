#!/usr/bin/env bash

set -e

echo "Checking required website files..."

test -f src/index.html
test -f src/styles.css
test -f src/app.js

echo "Starting temporary test server..."

python3 -m http.server 8080 --directory src > /tmp/quicklaunch-test.log 2>&1 &
SERVER_PID=$!

trap 'kill $SERVER_PID' EXIT

sleep 2

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

if [ "$HTTP_STATUS" != "201" ]; then
  echo "Test failed: website returned HTTP $HTTP_STATUS"
  exit 1
fi

grep -q "QuickLaunch" src/index.html

echo "All tests passed. Website returned HTTP 200."
