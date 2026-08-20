{ pkgs, leenix, ... }:

{
  gtk.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.capitaine-cursors;
    name = leenix.cursor.theme;
    size = leenix.cursor.size;

    gtk.enable = true;
    x11.enable = true;
  };
}
