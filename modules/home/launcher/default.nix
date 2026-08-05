{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    terminal = "kitty";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
      drun-display-format = "{name}";
      matching = "fuzzy";
      sorting-method = "fzf";
      sort = true;
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = false;
    };

    theme = {
      "*" = {
        background-color = "rgba (17, 18, 32, 95%)";
        foreground-color = "#cdd6f4";
        border-color = "#a6e3a1";
        selected-normal-background = "#313244";
        selected-normal-foreground = "#a6e3a1";
        font = "JetBrainsMono Nerd Font 13";
      };

      window = {
        width = "38%";
        border = "2px";
        border-radius = "14px";
        padding = "18px";
      };

      inputbar = {
        children = [ "prompt" "entry" ];
        padding = "10px";
        border-radius = "10px";
        background-color = "#1e1e2e";
      };

      prompt = {
        text-color = "#a6e3a1";
      };

      entry = {
        placeholder = "Search...";
        text-color = "#cdd6f4";
      };

      listview = {
        lines = 8;
        columns = 1;
        spacing = "6px";
        margin = "12px 0 0";
      };

      element = {
        padding = "10px";
        border-radius = "9px";
      };

      element-icon = {
        size = "24px";
        margin = "0 10px 0 0";
      };
    };
  };
}
