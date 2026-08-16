{
  pkgs,
  ...
}:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-waybar";

      runtimeInputs = with pkgs; [
        systemd
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart Waybar when desired state is enabled

        # leenix:examples=leenix restart waybar

        # This helper is NOT a visibility authority. It refreshes an
        # already-running, desired-enabled Waybar. Desired state is resolved
        # from leenix-waybar-state; if the user has persisted toggles/waybar =
        # disabled (or the capability is disabled), this is a no-op so an
        # ancillary script (timezone/voxtype/nightlight refresh) can never make
        # a desired-OFF Waybar visible. try-restart is used so an unexpectedly
        # inactive Waybar is NOT started here — only `leenix-toggle-waybar
        # on|apply` may start it.

        desired=$(leenix-waybar-state | sed -n 's/^desired: //p')

        if [[ $desired == "enabled" ]]; then
          systemctl --user try-restart waybar.service
        fi
        # desired=disabled → no-op, exit 0
      '';
    })
  ];
}
