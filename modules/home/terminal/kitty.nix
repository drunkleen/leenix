{ pkgs, ... }:

{
  home.packages = [
    pkgs.xdg-terminal-exec
  ];

  programs.kitty = {
    enable = true;

    settings = {
      shell = "${pkgs.zsh}/bin/zsh";

      # Colors
      foreground = "#d8e3e0";
      background = "#0b1113";
      selection_foreground = "#f2f8f6";
      selection_background = "#365156";

      cursor = "#d8e3e0";
      cursor_text_color = "#0b1113";

      active_border_color = "#33b8a8";
      active_tab_background = "#33b8a8";

      color0 = "#182326";
      color1 = "#e16f73";
      color2 = "#4dba7a";
      color3 = "#d9c76b";
      color4 = "#5e9bff";
      color5 = "#59d6c5";
      color6 = "#33b8a8";
      color7 = "#c0cecb";
      color8 = "#4a5f62";
      color9 = "#f08787";
      color10 = "#67cf94";
      color11 = "#efd45e";
      color12 = "#78acff";
      color13 = "#71e4d8";
      color14 = "#5ccbbb";
      color15 = "#f2f8f6";

      # Font
      font_family = "JetBrainsMono Nerd Font";
      bold_italic_font = "auto";
      font_size = 14.0;

      # Window
      window_padding_width = 14;
      hide_window_decorations = true;
      confirm_os_window_close = 0;

      # Keybindings
      "map ctrl+insert" = "copy_to_clipboard";
      "map shift+insert" = "paste_from_clipboard";

      "map shift+enter" = "send_text all \\e[13;2u";
      "map alt+shift+enter" = "send_text all \\e[13;4u";

      # Remote control
      allow_remote_control = true;

      # Aesthetics
      cursor_shape = "block";
      cursor_blink_interval = 0;
      shell_integration = "no-cursor";
      enable_audio_bell = false;

      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template =
        "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
  };
}
