{ inputs, ... }:

let
  palette = import ../../../lib/leenium.nix;

  style =
    builtins.replaceStrings
      [
        "@LEENIUM_FOREGROUND@"
        "@LEENIUM_BACKGROUND@"
        "@LEENIUM_TEAL@"
        "@LEENIUM_POPUP@"
        "@LEENIUM_DISABLED@"
        "@LEENIUM_SELECTION@"
        "@LEENIUM_BRIGHT@"
        "@LEENIUM_CYAN@"
        "@LEENIUM_SECONDARY@"
      ]
      [
        palette.neutral.foreground
        palette.background.main
        palette.accent.teal
        palette.background.popup
        palette.neutral.disabled
        palette.background.selection
        palette.neutral.bright
        palette.accent.cyan
        palette.neutral.secondary
      ]
      (builtins.readFile ./theme/style.css);
in
{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    themes."leenium.hyprland" = {
      inherit style;
      layouts = {
        layout = builtins.readFile ./theme/layout.xml;
      };
    };

    config = {
      force_keyboard_focus = true;
      selection_wrap = true;
      hide_action_hints = true;
      theme = "leenium.hyprland";

      placeholders.default = {
        input = " Search...";
        list = "No Results";
      };

      keybinds.quick_activate = [ ];

      columns.symbols = 1;

      providers = {
        max_results = 256;

        default = [
          "desktopapplications"
          "websearch"
        ];

        prefixes = [
          {
            prefix = "/";
            provider = "providerlist";
          }
          {
            prefix = ".";
            provider = "files";
          }
          {
            prefix = ":";
            provider = "symbols";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = "@";
            provider = "websearch";
          }
          {
            prefix = "$";
            provider = "clipboard";
          }
        ];
      };
    };
  };
}
