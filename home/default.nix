{
  pkgs,
  variables,
  ...
}:

{
  home.username = variables.user.username;
  home.homeDirectory = variables.user.homeDirectory;
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      monitor = [
        ",preferred,auto,1"
      ];

      exec-once = [
        "kitty"
      ];

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, C, exec, code"

        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"

        "$mod, V, exec, wl-paste"
      ];

      input = {
        kb_layout =
          builtins.concatStringsSep "," variables.keyboard.layouts;

        kb_options =
          builtins.concatStringsSep "," variables.keyboard.options;
      };
    };
  };
}
