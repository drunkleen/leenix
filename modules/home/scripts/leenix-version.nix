{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-version";

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Print the installed Leenix version

        cat "$LEENIX_PATH/version"
      '';
    })
  ];
}