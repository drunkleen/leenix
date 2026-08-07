{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.leenix;
  shellPackage = pkgs.callPackage ../../../packages/leenix-shell { };
  shellTarget = "wayland-session@leenix\\x2duwsm.desktop.target";
in
{
  options.leenix = {
    desktop.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the current Leenix desktop capability profile.";
    };

    shell = {
      enable = lib.mkEnableOption "the parallel Leenix Quickshell session";

      sessionName = lib.mkOption {
        type = lib.types.str;
        default = "Leenix";
        description = "Display name for the parallel Leenix session.";
      };

      stateDirectory = lib.mkOption {
        type = lib.types.str;
        default = "leenix";
        description = "Relative XDG state directory for the Leenix shell.";
      };
    };
  };

  config = lib.mkIf cfg.shell.enable {
    environment.systemPackages = [ shellPackage ];

    programs.uwsm.waylandCompositors.leenix = {
      prettyName = cfg.shell.sessionName;
      comment = "Leenix Quickshell desktop";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };

    systemd.user.services.leenix-shell = {
      description = "Leenix Quickshell desktop";
      after = [ shellTarget ];
      partOf = [ shellTarget ];
      wantedBy = [ shellTarget ];
      startLimitIntervalSec = 30;
      startLimitBurst = 3;
      serviceConfig = {
        ExecStart = lib.getExe shellPackage;
        Restart = "on-failure";
        Environment = "XDG_STATE_HOME=%h/.local/state/${cfg.shell.stateDirectory}";
      };
    };
  };
}
