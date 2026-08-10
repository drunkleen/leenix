{
  config,
  lib,
  ...
}:

let
  cfg = config.leenix.desktop.uwsm;
in
{
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = config.leenix.desktop.hyprland.enable;
      withUWSM = true;
    };
  };
}
