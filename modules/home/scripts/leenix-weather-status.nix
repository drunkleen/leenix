{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-weather-status";

      runtimeInputs = with pkgs; [
        curl
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns a formatted weather status string with temperature and wind speed.

        weather=$(curl -fsS --max-time 4 \
          "https://wttr.in?format=%l|%t|%w" 2>/dev/null | tr -d '\n')

        if [[ -z $weather ]]; then
          echo "Weather unavailable"
          exit 1
        fi

        IFS='|' read -r place temperature wind <<< "$weather"

        place=''${place%%,*}
        place=''${place^}
        temperature=''${temperature#+}

        echo "$(leenix-weather-icon)    $place  ·  Temp $temperature  ·  Wind $wind"
      '';
    })
  ];
}