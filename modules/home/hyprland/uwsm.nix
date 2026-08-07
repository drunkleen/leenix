{ lib, ... }:

{
  options.leenix.fallbackSession.target = lib.mkOption {
    type = lib.types.str;
    default = "wayland-session@leenix\\x2duwsm.desktop.target";
    description = "UWSM target that owns the retained Hyprland fallback desktop services.";
  };
}
