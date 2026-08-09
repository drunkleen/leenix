{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-webapp-handler-zoom";

      runtimeInputs = with pkgs; [
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Open Zoom web meetings from browser protocol links

        # leenix:args=[url]

        url="$1"
        web_url="https://app.zoom.us/wc/home"

        if [[ $url =~ ^zoom(mtg|us):// ]]; then
          confno=$(echo "$url" | sed -n 's/.*[?&]confno=\([^&]*\).*/\1/p')

          if [[ -n $confno ]]; then
            pwd=$(echo "$url" | sed -n 's/.*[?&]pwd=\([^&]*\).*/\1/p')

            if [[ -n $pwd ]]; then
              web_url="https://app.zoom.us/wc/join/$confno?pwd=$pwd"
            else
              web_url="https://app.zoom.us/wc/join/$confno"
            fi
          fi
        fi

        exec leenix-launch-webapp "$web_url"
      '';
    })
  ];
}