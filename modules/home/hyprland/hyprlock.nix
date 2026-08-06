let
  palette = import ../../../lib/leenium.nix;
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = "";
          color = palette.rgba palette.background.main "ff";
          blur_passes = 3;
        }
      ];

      animations = {
        enabled = false;
      };

      input-field = [
        {
          monitor = "";

          size = "650, 100";
          position = "0, 0";

          halign = "center";
          valign = "center";

          inner_color = palette.rgba palette.background.main "ee";
          outer_color = palette.rgba palette.accent.teal "ff";
          outline_thickness = 4;

          font_family = "JetBrainsMono Nerd Font";
          font_color = palette.rgba palette.neutral.foreground "ff";

          placeholder_text = "Enter Password";
          check_color = palette.rgba palette.accent.emerald "ff";
          fail_color = palette.rgba palette.accent.red "ff";
          fail_text = "<i>$FAIL ($ATTEMPTS)</i>";

          rounding = 0;
          shadow_passes = 0;
          fade_on_empty = false;
        }
      ];

      auth = {
        "fingerprint:enabled" = false;
      };
    };
  };
}
