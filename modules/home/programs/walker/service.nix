{ pkgs, ... }:

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
}
