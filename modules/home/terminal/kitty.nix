let
  palette = import ../../../lib/leenium.nix;
in
{
  programs.kitty = {
    enable = true;

    settings = {
      background = palette.background.main;
      foreground = palette.neutral.foreground;

      cursor = palette.accent.cyan;
      cursor_text_color = palette.background.main;

      selection_background = palette.background.selection;
      selection_foreground = palette.neutral.bright;

      color0 = palette.neutral.baseBlack;
      color1 = palette.accent.red;
      color2 = palette.accent.emerald;
      color3 = palette.accent.yellow;
      color4 = palette.accent.blue;
      color5 = palette.accent.orange;
      color6 = palette.accent.cyan;
      color7 = palette.neutral.foreground;

      color8 = palette.neutral.disabled;
      color9 = palette.accent.red;
      color10 = palette.accent.emerald;
      color11 = palette.accent.yellow;
      color12 = palette.accent.blue;
      color13 = palette.accent.orange;
      color14 = palette.accent.teal;
      color15 = palette.neutral.bright;
    };
  };
}
