let
  leenium = import ../../../lib/leenium.nix;
in
{
  programs.firefox = {
    enable = true;

    policies.Preferences = {
      "ui.systemUsesDarkTheme" = {
        Value = 1;
        Status = "locked";
      };
      "widget.content.allow-gtk-dark-theme" = {
        Value = true;
        Status = "locked";
      };
      "layout.css.prefers-color-scheme.content-override" = {
        Value = 2;
        Status = "locked";
      };
      "browser.display.use_system_colors" = {
        Value = false;
        Status = "locked";
      };
      "browser.display.background_color" = {
        Value = leenium.neutral.background;
        Status = "locked";
      };
      "browser.display.foreground_color" = {
        Value = leenium.neutral.foreground;
        Status = "locked";
      };
      "browser.anchor_color" = {
        Value = leenium.accent.cyan;
        Status = "locked";
      };
      "browser.visited_color" = {
        Value = leenium.accent.blue;
        Status = "locked";
      };
    };
  };
}
