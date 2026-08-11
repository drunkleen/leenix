{
  lib,
  pkgs,
  themeMode,
  ...
}:

let
  inherit (lib) mkDefault;

  dark = themeMode == "dark";
in
{
  gtk = {
    enable = mkDefault true;
    colorScheme = if dark then "dark" else "light";
  };

  # glib settings schema required for apps and xdg-desktop-portal-gtk to read
  # the color-scheme preference from dconf.
  home.packages = [
    pkgs.gsettings-desktop-schemas
  ];
}
