{ ... }:

{
  # Universal LEENIX scripts: installed on every host via the base profile.
  # Must remain headless-safe (no Hyprland, Wayland, audio, or laptop deps).
  imports = [
    ./leenix-branding-about.nix
    ./leenix-cmd-missing.nix
    ./leenix-cmd-present.nix
    ./leenix-cmd-terminal-cwd.nix
    ./leenix-config.nix
    ./leenix-config-language.nix
    ./leenix-config-timezone.nix
    ./leenix-debug.nix
    ./leenix-default-editor.nix
    ./leenix-default-terminal.nix
    ./leenix-hook.nix
    ./leenix-hook-install.nix
    ./leenix-launch-about.nix
    ./leenix-launch-editor.nix
    ./leenix-notification-dismiss.nix
    ./leenix-notification-send.nix
    ./leenix-npx-install.nix
    ./leenix-rebuild.nix
    ./leenix-show-done.nix
    ./leenix-show-logo.nix
    ./leenix-state.nix
    ./leenix-system-apply.nix
    ./leenix-toggle.nix
    ./leenix-toggle-enabled.nix
    ./leenix-tz-select.nix
  ];
}
