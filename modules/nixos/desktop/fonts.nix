{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      liberation_ttf
      dejavu_fonts
      font-awesome
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font Mono"
          "DejaVu Sans Mono"
        ];

        sansSerif = [
          "Noto Sans"
          "DejaVu Sans"
        ];

        serif = [
          "Noto Serif"
          "DejaVu Serif"
        ];

        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
