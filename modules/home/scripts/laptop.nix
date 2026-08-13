{ ... }:

{
  # Laptop scripts: battery, brightness, power profiles, internal monitor,
  # touchpad/touchscreen input. Installed only with the laptop profile.
  imports = [
    ./leenix-ac-present.nix
    ./leenix-battery-capacity.nix
    ./leenix-battery-monitor.nix
    ./leenix-battery-present.nix
    ./leenix-battery-remaining-time.nix
    ./leenix-battery-remaining.nix
    ./leenix-battery-status.nix
    ./leenix-brightness-display.nix
    ./leenix-brightness-keyboard-mute.nix
    ./leenix-brightness-keyboard.nix
    ./leenix-hw-recover-internal-monitor.nix
    ./leenix-hw-touchpad.nix
    ./leenix-hw-touchscreen.nix
    ./leenix-monitor-laptop.nix
    ./leenix-powerprofiles-init.nix
    ./leenix-powerprofiles-list.nix
    ./leenix-powerprofiles-set.nix
    ./leenix-restart-trackpad.nix
    ./leenix-toggle-touchpad.nix
    ./leenix-toggle-touchscreen.nix
  ];
}
