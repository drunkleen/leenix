{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-webapp-handler-hey";
      excludeShellChecks = [ "SC2001" ];

      runtimeInputs = with pkgs; [
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Open HEY webmail and translate mailto links

        # leenix:args=[url]

        url="$1"
        web_url="https://app.hey.com"

        # Handle mailto: URLs

        if [[ $url =~ ^mailto: ]]; then
          email=$(echo "$url" | sed 's/mailto://')
          web_url="https://app.hey.com/messages/new?to=$email"
        fi

        exec leenix-launch-webapp "$web_url"
      '';
    })
  ];
}