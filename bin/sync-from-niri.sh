#!/usr/bin/env bash
# Not enabled: one-shot query of niri's focused window, then update Waybar.
# Matching snippets in hints.json win; otherwise the window title/app_id is shown.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

win="$(niri msg --json focused-window 2>/dev/null || true)"
if [[ -z "$win" || "$win" == "null" ]]; then
  barinfoo_write_hint ""
  exit 0
fi

app_id="$(jq -r '.app_id // ""' <<<"$win")"
title="$(jq -r '.title // ""' <<<"$win")"

matched="$(
  jq -r --arg app "$app_id" --arg title "$title" '
    def hay($s): ($s | ascii_downcase);
    [
      .snippets[]
      | select(
          ((.match_app_id // []) | map(. as $p | hay($app) | contains(hay($p))) | any)
          or
          ((.match_title // []) | map(. as $p | hay($title) | contains(hay($p))) | any)
        )
      | .text
    ] | first // empty
  ' "$BARINFOO_HINTS"
)"

if [[ -n "$matched" ]]; then
  barinfoo_write_hint "$matched"
else
  barinfoo_write_hint "${title:-$app_id}"
fi
