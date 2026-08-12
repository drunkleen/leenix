{ pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;

    settings = {
      general = {
        lock_cmd = "leenix-system-lock";
        before_sleep_cmd = "LEENIX_LOCK_ONLY=true leenix-system-lock";
        after_sleep_cmd = "sleep 1 && leenix-system-wake";
        inhibit_sleep = 3;
      };

      listener = [
        {
          timeout = 90;
          on-timeout = "leenix-launch-screensaver";
        }
        {
          timeout = 300;
          on-timeout = "leenix-system-lock";
          on-resume = "leenix-system-wake";
        }
      ];
    };
  };
}
