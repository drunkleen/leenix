{ config, lib, ... }:

{
  # MangoHud: per-game performance overlay (fps, frametime, GPU/CPU usage,
  # temperatures, VRAM/RAM). Enabled on demand per game; not session-wide.
  programs.mangohud = {
    enable = true;
    enableSessionWide = false;

    settings = {
      fps_limit = 0;
      vsync = 0;
      fps = true;
      frametime = true;
      gpu_stats = true;
      gpu_temp = true;
      vram = true;
      cpu_stats = true;
      core_load = true;
      cpu_temp = true;
      ram = true;
      position = "top-right";
      font_size = 16;
      background_alpha = 0.6;
      toggle_hud = "Shift_R+F12";
    };
  };
}
