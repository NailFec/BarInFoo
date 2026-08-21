# shellcheck shell=bash
# Shared paths and helpers. Sourced by the other scripts; not executed directly.

BARINFOO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BARINFOO_HINTS="${BARINFOO_HINTS:-$BARINFOO_ROOT/hints.json}"
BARINFOO_STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/barinfoo"
BARINFOO_STATE="$BARINFOO_STATE_DIR/current-hint.txt"
BARINFOO_WAYBAR_SIGNAL="${BARINFOO_WAYBAR_SIGNAL:-8}"

barinfoo_default_hint() {
  jq -r '.default // ""' "$BARINFOO_HINTS"
}

barinfoo_current_hint() {
  if [[ -f "$BARINFOO_STATE" ]]; then
    cat "$BARINFOO_STATE"
  else
    barinfoo_default_hint
  fi
}

barinfoo_write_hint() {
  local text="$1"
  mkdir -p "$BARINFOO_STATE_DIR"
  printf '%s' "$text" > "$BARINFOO_STATE"
  pkill -RTMIN+"$BARINFOO_WAYBAR_SIGNAL" waybar 2>/dev/null || true
}
