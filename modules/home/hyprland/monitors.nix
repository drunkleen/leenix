{
  lib,
  ...
}:

{
  # Nix-owned SAFE DEFAULT monitor policy only. HyprMon (hyprmon.lua, loaded
  # after this in hyprland.lua) is the runtime monitor-layout owner and
  # overrides these defaults. Keeping a single built-in default here guarantees
  # a fresh host (no hyprmon.lua yet) never boots to a black screen.
  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "eDP-1";
        mode = "preferred";
        # Lua API uses "0x0" (HyprMon format); "0,0" is rejected by hl.monitor.
        position = "0x0";
        scale = 1;
      }
    ];
  };
}
