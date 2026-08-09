{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-xcompose";

      text = ''
        #!/bin/bash

        # leenix:summary=Restart the XCompose input method service (fcitx5) to apply new compose key settings.

        leenix-restart-app fcitx5 --disable notificationitem
      '';
    })
  ];
}