{
  lib,
  pkgs,
  ...
}:

{
  systemd.user.services.walker = {
    Unit = {
      Description = "Walker launcher service";
      PartOf = [ "graphical-session.target" ];
      After = [
        "graphical-session.target"
        "elephant.service"
      ];
      Wants = [ "elephant.service" ];
    };

    Service = {
      Type = "dbus";
      BusName = "dev.benz.walker";
      ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
      Environment = "GSK_RENDERER=cairo";
      Restart = "always";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Walker caches its theme map (layout/style) at startup. Restart the service
  # after every HM activation so the running service picks up theme/config
  # changes (e.g. a new switch adds the leenix-menu theme) immediately, instead
  # of falling back to the bare built-in theme. Restarting the launcher service
  # is cheap and only happens when the service is active.
  home.activation.restartWalkerAfterConfigChange = lib.hm.dag.entryAfter [
    "writeBoundary"
  ] ''
    if systemctl --user is-active --quiet walker.service; then
      systemctl --user restart walker.service >/dev/null 2>&1 || true
    fi
  '';
}
