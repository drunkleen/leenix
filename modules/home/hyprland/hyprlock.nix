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
          color = "rgba(0b1113ff)";
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

          inner_color = "rgba(0b1113ee)";
          outer_color = "rgba(33b8a8ff)";
          outline_thickness = 4;

          font_family = "JetBrainsMono Nerd Font";
          font_color = "rgba(d8e3e0ff)";

          placeholder_text = "Enter Password";
          check_color = "rgba(4dba7aff)";
          fail_color = "rgba(e16f73ff)";
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