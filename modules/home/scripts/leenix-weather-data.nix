{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-weather-data";

      runtimeInputs = with pkgs; [
        curl
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Fetches structured weather data (wttr.in JSON). Single network boundary shared by all leenix-weather-* consumers.

        curl -fsS --max-time 4 "https://wttr.in?format=j1" || exit 1
      '';
    })
  ];
}
