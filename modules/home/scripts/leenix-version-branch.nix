{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-version-branch";
      excludeShellChecks = [ "SC2005" ];

      runtimeInputs = with pkgs; [
        git
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Print the current Leenix git branch

        echo "$(git -C "$LEENIX_PATH" rev-parse --abbrev-ref HEAD)"
      '';
    })
  ];
}