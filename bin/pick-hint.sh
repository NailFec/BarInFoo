#!/usr/bin/env bash
# Enabled: open fuzzel, filter snippets from hints.json, write the pick to Waybar.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

if [[ ! -f "$BARINFOO_HINTS" ]]; then
  echo "BarInFoo: missing $BARINFOO_HINTS" >&2
  exit 1
fi

choice="$(
  jq -r '
    .snippets[]
    | [.text, ((.search // "") + " " + .text)]
    | @tsv
  ' "$BARINFOO_HINTS" \
    | fuzzel --dmenu \
      --prompt="hint> " \
      --with-nth=1 \
      --accept-nth=1 \
      --match-nth=2 \
      --only-match \
      --log-level=error \
      --lines=12 \
      --width=80 \
    || true
)"

[[ -z "${choice}" ]] && exit 0
barinfoo_write_hint "$choice"
