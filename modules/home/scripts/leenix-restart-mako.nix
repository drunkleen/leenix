{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-mako";

      runtimeInputs = with pkgs; [
        mako
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reload mako configuration (used by the Leenix theme switching).

        makoctl reload
      '';
    })
  ];
}