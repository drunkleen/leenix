{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "lua";

    settings = {
      misc = {
        allow_session_lock_restore = true;
      };
    };

    extraConfig = ''
      # Leenix defaults
      # source = ~/.local/share/leenix/default/hypr/input.conf
      # source = ~/.config/leenix/current/theme/hyprland.conf

      # Leenix toggles
      # source = ~/.local/state/leenix/toggles/hypr/*.conf

    '';
  };
}
