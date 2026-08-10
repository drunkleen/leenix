{ pkgs, variables, ... }:

{
  gtk.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.capitaine-cursors;
    name = variables.cursor.theme;
    size = variables.cursor.size;

    gtk.enable = true;
    x11.enable = true;
  };
}
