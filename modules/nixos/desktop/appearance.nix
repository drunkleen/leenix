{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.leenix.profiles.desktop.enable {
    programs.dconf.enable = true;

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      config.common.default = lib.mkDefault [ "gtk" ];
    };
  };
}
