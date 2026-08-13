{ ... }:

{
  # Hyprland scripts: IPC helpers, monitors, window ops, Waybar/Hypridle/
  # Hyprsunset control, screensaver. Installed only when the Hyprland desktop
  # capability is enabled.
  imports = [
    ./leenix-audio-input-mute.nix
    ./leenix-audio-output-switch.nix
    ./leenix-branding-screensaver.nix
    ./leenix-hw-external-monitors.nix
    ./leenix-hypr-zoom.nix
    ./leenix-hyprland-monitor-focused-apple.nix
    ./leenix-hyprland-monitor-focused.nix
    ./leenix-hyprland-monitor-internal-mirror.nix
    ./leenix-hyprland-monitor-internal.nix
    ./leenix-hyprland-monitor-scaling-cycle.nix
    ./leenix-hyprland-monitor-watch.nix
    ./leenix-hyprland-toggle-disabled.nix
    ./leenix-hyprland-toggle-enabled.nix
    ./leenix-hyprland-window-close-all.nix
    ./leenix-hyprland-window-gaps-toggle.nix
    ./leenix-hyprland-window-pop.nix
    ./leenix-hyprland-window-single-square-aspect-toggle.nix
    ./leenix-hyprland-window-transparency-toggle.nix
    ./leenix-hyprland-workspace-layout-toggle.nix
    ./leenix-launch-floating-terminal-with-presentation.nix
    ./leenix-launch-screensaver.nix
    ./leenix-restart-hyprctl.nix
    ./leenix-restart-hypridle.nix
    ./leenix-restart-hyprsunset.nix
    ./leenix-restart-waybar.nix
    ./leenix-screensaver.nix
    ./leenix-toggle-idle.nix
    ./leenix-toggle-nightlight.nix
    ./leenix-toggle-screensaver.nix
    ./leenix-toggle-waybar.nix
  ];
}
