{
  config,
  lib,
  pkgs,
  ...
}:

let
  leenixTheme = import ./plymouth {
    inherit (pkgs) stdenvNoCC;
  };
in

{
  config = lib.mkIf config.leenix.boot.plymouth.enable {
    boot.plymouth = {
      enable = true;
      theme = "leenix";
      themePackages = [ leenixTheme ];
    };

    # Plymouth must leave its last DRM frame visible until the session
    # compositor performs the next modeset, preventing the bare VT from
    # appearing during SDDM autologin/UWSM startup. retain-splash skips the
    # explicit splash hide (and the KD_TEXT/VT teardown) on plymouthd exit, so
    # the framebuffer persists until Hyprland takes over the display.
    #
    # ExecStart is a list-type setting: a drop-in ExecStart= appends to the
    # packaged unit's ExecStart unless reset first. The leading "" emits an
    # empty ExecStart= line so the packaged `plymouth quit` is fully replaced
    # instead of running both commands on the next boot.
    systemd.services.plymouth-quit.serviceConfig.ExecStart = [
      "" # reset the packaged ExecStart
      "-${lib.getExe' config.boot.plymouth.package "plymouth"} quit --retain-splash"
    ];
  };
}
