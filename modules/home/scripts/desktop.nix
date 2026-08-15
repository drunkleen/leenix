{ ... }:

{
  # Desktop scripts: LEENIX menu, capture, launchers, OSD helpers, app
  # restarts, notification silencing, and desktop-oriented tools (reminder,
  # weather, voxtype dictation). Installed only with the desktop profile.
  imports = [
    ./leenix-capture-screenrecording.nix
    ./leenix-capture-screenshot.nix
    ./leenix-capture-text-extraction.nix
    ./leenix-launch-audio.nix
    ./leenix-launch-or-focus.nix
    ./leenix-launch-or-focus-tui.nix
    ./leenix-launch-tui.nix
    ./leenix-launch-walker.nix
    ./leenix-menu-file.nix
    ./leenix-menu-input.nix
    ./leenix-menu-keybindings.nix
    ./leenix-menu-select.nix
    ./leenix-menu-share.nix
    ./leenix-menu.nix
    ./leenix-menu-width.nix
    ./leenix-camera.nix
    ./leenix-desktop-state-apply.nix
    # Interactive Tailscale Send File UX: Walker device selector + file picker.
    # Tailscale status/up/down/ip stay in the base group (headless-safe).
    ./leenix-tailscale-send.nix
    ./leenix-reminder.nix
    ./leenix-restart-app.nix
    ./leenix-restart-btop.nix
    ./leenix-restart-helix.nix
    ./leenix-restart-mako.nix
    ./leenix-restart-opencode.nix
    ./leenix-restart-pipewire.nix
    ./leenix-restart-swayosd.nix
    ./leenix-restart-terminal.nix
    ./leenix-restart-tmux.nix
    ./leenix-restart-walker.nix
    ./leenix-restart-xcompose.nix
    ./leenix-swayosd-brightness.nix
    ./leenix-swayosd-client.nix
    ./leenix-swayosd-kbd-brightness.nix
    ./leenix-theme-list.nix
    ./leenix-toggle-notification-silencing.nix
    ./leenix-voxtype-config.nix
    ./leenix-voxtype-model.nix
    ./leenix-voxtype-status.nix
    ./leenix-weather-data.nix
    ./leenix-weather-icon.nix
    ./leenix-weather-status.nix
  ];
}
