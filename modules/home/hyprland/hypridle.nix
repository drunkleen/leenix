{ config, lib, ... }:

{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # Optional suspend after 30 minutes.
        # فعلاً غیرفعال است. برای فعال‌کردن، این block را uncomment کن.
        #
        # {
        #   timeout = 1800;
        #   on-timeout = "systemctl suspend";
        # }
      ];
    };
  };

  systemd.user.services.hypridle = {
    Unit = {
      After = lib.mkForce [ config.leenix.fallbackSession.target ];
      PartOf = lib.mkForce [ config.leenix.fallbackSession.target ];
    };
    Install.WantedBy = lib.mkForce [ config.leenix.fallbackSession.target ];
  };
}
