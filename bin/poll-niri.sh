#!/usr/bin/env bash
# Not enabled: ask niri for the focused window every 30s and refresh Waybar.
set -euo pipefail
INTERVAL="${BARINFOO_POLL_SECONDS:-30}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
  "$DIR/sync-from-niri.sh" || true
  sleep "$INTERVAL"
done
