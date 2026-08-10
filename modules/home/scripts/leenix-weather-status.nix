{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-weather-status";

      runtimeInputs = with pkgs; [
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns a formatted weather status string with temperature and wind speed.

        if [[ ''${1:-} == "-" ]]; then
          data=$(cat)
        else
          data=$(leenix-weather-data 2>/dev/null) || { echo "Weather unavailable"; exit 1; }
        fi

        icon=$(printf '%s' "''$data" | leenix-weather-icon - 2>/dev/null) || { echo "Weather unavailable"; exit 1; }

        place=$(printf '%s' "''$data" | jq -r '.nearest_area[0].areaName[0].value')
        place=''${place%%,*}
        place=''${place^}

        temperature=$(printf '%s' "''$data" | jq -r '.current_condition[0].temp_C')

        dir=$(printf '%s' "''$data" | jq -r '.current_condition[0].winddir16Point')
        speed=$(printf '%s' "''$data" | jq -r '.current_condition[0].windspeedKmph')

        case "''$dir" in
          N) arrow="↓" ;;
          NNE|NE) arrow="↙" ;;
          ENE|E) arrow="←" ;;
          ESE|SE) arrow="↖" ;;
          SSE|S) arrow="↑" ;;
          SSW|SW) arrow="↗" ;;
          WSW|W) arrow="→" ;;
          WNW|NW|NNW) arrow="↘" ;;
          *) arrow="" ;;
        esac

        echo "''$icon    ''$place  ·  Temp ''$temperature°C  ·  Wind ''$arrow''${speed}km/h"
      '';
    })
  ];
}
