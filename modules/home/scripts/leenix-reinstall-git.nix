{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-reinstall-git";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        git
        coreutils
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Reinstall the Leenix source directory from git

        set -e

        # Reinstall the Leenix configuration directory from the git source.

        git clone --depth=1 --branch master "https://github.com/basecamp/leenix.git" ~/.local/share/leenix-new >/dev/null
        mv $LEENIX_PATH ~/.local/share/leenix-old
        mv ~/.local/share/leenix-new $LEENIX_PATH
      '';
    })
  ];
}