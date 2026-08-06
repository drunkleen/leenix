#!/usr/bin/env bash

set -euo pipefail

device="${LEENIX_TOUCHPAD_DEVICE:?Touchpad device is not configured}"
state_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
state_file="$state_dir/leenix-touchpad-disabled"

if [[ -e "$state_file" ]]; then
  hyprctl keyword "device[$device]:enabled" true >/dev/null
  rm -f "$state_file"

  swayosd-client \
    --custom-message "Touchpad enabled" \
    --custom-icon "input-touchpad-symbolic"
else
  hyprctl keyword "device[$device]:enabled" false >/dev/null
  touch "$state_file"

  swayosd-client \
    --custom-message "Touchpad disabled" \
    --custom-icon "touchpad-disabled-symbolic"
fi
