{
  lib,
  pkgs,
  leenix,
  ...
}:

let
  inherit (lib) mkDefault;

  dark = leenix.theme.mode == "dark";
in
{
  gtk = {
    enable = mkDefault true;
    colorScheme = if dark then "dark" else "light";

    gtk4.extraConfig = {
      # home-manager writes the gtk-interface-color-scheme enum as an integer
      # (2/3), but GTK 4.20+ parses it via g_enum_get_value_by_nick, so only the
      # string nicks "dark"/"light" are accepted. Override with the valid nick.
      "gtk-interface-color-scheme" = if dark then "dark" else "light";
    };
  };

  # glib settings schema required for apps and xdg-desktop-portal-gtk to read
  # the color-scheme preference from dconf.
  home.packages = [
    pkgs.gsettings-desktop-schemas
  ];
}
