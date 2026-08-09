{ pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;

    package = pkgs.writeShellApplication {
      name = "hyprlock";
      runtimeInputs = [ pkgs.hyprlock ];
      text = ''
        exec env LD_LIBRARY_PATH=/usr/lib hyprlock "$@"
        '';
    };

    # Use Leenix/Arch's hyprlock so its existing PAM/YubiKey
    # integration remains untouched.
    # package = null;

    settings = {
      "$color" = "rgba(11,17,19,1.0)";
      "$inner_color" = "rgba(11,17,19,0.8)";
      "$outer_color" = "rgba(216,227,224,1.0)";
      "$font_color" = "rgba(216,227,224,1.0)";
      "$check_color" = "rgba(51,184,168,1.0)";

      general = {
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = "";
          color = "$color";
          path = "~/.config/leenix/current/background";
          blur_passes = 3;
        }
      ];

      animations = {
        enabled = false;
      };

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgb(242, 248, 246)";
          font_family = "JetBrainsMono Nerd Font";
          font_size = 96;
          position = "0, 220";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "cmd[update:60000] date '+%A, %B %-d'";
          color = "rgba(192, 206, 203, 0.75)";
          font_family = "JetBrainsMono Nerd Font";
          font_size = 22;
          position = "0, 115";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "650, 100";
          position = "0, 0";
          halign = "center";
          valign = "center";

          inner_color = "$inner_color";
          outer_color = "$outer_color";
          outline_thickness = 4;

          font_family = "JetBrainsMono Nerd Font";
          font_color = "$font_color";

          placeholder_text = "Enter Password";
          check_color = "$check_color";
          fail_text = "<i>$FAIL ($ATTEMPTS)</i>";

          rounding = 0;
          shadow_passes = 0;
          fade_on_empty = false;
        }
      ];

      auth = {
        "pam:enabled" = true;
        "pam:module" = "hyprlock";
        "fingerprint:enabled" = false;
      };

      
    };
  };
}
