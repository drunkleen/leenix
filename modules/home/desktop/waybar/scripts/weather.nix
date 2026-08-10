{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "leenix-waybar-weather";

  runtimeInputs = with pkgs; [
    jq
  ];

  text = ''
    #!/bin/bash

    data=$(leenix-weather-data 2>/dev/null) || {
      printf '{"text":"","class":"unavailable"}\n'
      exit 0
    }

    icon=$(printf '%s' "''$data" | leenix-weather-icon - 2>/dev/null) || icon=""
    temperature=$(printf '%s' "''$data" | jq -r '.current_condition[0].temp_C' 2>/dev/null) || temperature=""

    if [[ -z ''$icon || ! ''$temperature =~ ^-?[0-9]+$ ]]; then
      printf '{"text":"","class":"unavailable"}\n'
      exit 0
    fi

    text="''$icon ''$temperature°C"
    tooltip=$(printf '%s' "''$data" | leenix-weather-status - 2>/dev/null) || tooltip=""

    printf '{"text":%s,"tooltip":%s}\n' \
      "$(printf '%s' "''$text" | jq -Rs .)" \
      "$(printf '%s' "''$tooltip" | jq -Rs .)"
  '';
}
