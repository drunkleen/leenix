{ ... }:

# LEENIUM Limine appearance. Translated declaratively from the fixed LEENIUM
# bootloader theme (source: https://github.com/drunkleen/leenium.limine
# commit 72313acd00f2f2a29333028eec73de5a92ef5717) into native NixOS Limine
# options. The theme is palette-driven (solid #0b1113 backdrop); no wallpaper.
{
  boot.loader.limine.style = {
    # No NixOS default artwork: solid LEENIUM backdrop.
    wallpapers = [ ];
    backdrop = "0b1113";

    interface = {
      branding = "Leenium Bootloader";
      brandingColor = "33b8a8";
      helpColor = "59d6c5";
      helpColorBright = "5ccbbb";
    };

    graphicalTerminal = {
      palette = "182326;e16f73;4dba7a;d9c76b;5e9bff;59d6c5;33b8a8;c0cecb";
      brightPalette = "4a5f62;f08787;67cf94;efd45e;78acff;71e4d8;5ccbbb;f2f8f6";
      foreground = "d8e3e0";
      brightForeground = "f2f8f6";
      background = "0b1113";
      brightBackground = "11191c";
    };
  };
}
