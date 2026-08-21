#!/usr/bin/env bash
# Waybar custom module: print the current hint as JSON.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

text="$(barinfoo_current_hint)"
jq -nc --arg text "$text" '{text: $text}'
