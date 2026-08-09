{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-available";
      excludeShellChecks = [ "SC2053" ];

      runtimeInputs = with pkgs; [
        git
        gnugrep
        gawk
        gnused
        coreutils
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Get remote tag

        latest_tag=$(git -C "$LEENIX_PATH" ls-remote --tags origin |
          grep -v "{}" |
          awk '{print $2}' |
          sed 's#refs/tags/##' |
          sort -V |
          tail -n 1)

        if [[ -z $latest_tag ]]; then
          echo "Error: Could not retrieve latest tag."
          exit 1
        fi

        # Get local tag

        current_tag=$(git -C "$LEENIX_PATH" describe --tags "$(git -C "$LEENIX_PATH" rev-list --tags --max-count=1)")

        if [[ -z $current_tag ]]; then
          echo "Error: Could not retrieve current tag."
          exit 1
        fi

        if [[ $current_tag != $latest_tag ]]; then
          echo "Leenix update available ($latest_tag)"
          exit 0
        else
          echo "Leenix is up to date ($current_tag)"
          exit 1
        fi
      '';
    })
  ];
}