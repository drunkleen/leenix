{ pkgs, ... }:

{
  gtk = {
    enable = true;

    # colorScheme = "dark";

    font = {
      name = "Noto Sans";
      size = 11;
      package = pkgs.noto-fonts;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
      gtk-enable-animations = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
      gtk-enable-animations = true;
    };
  };
}
