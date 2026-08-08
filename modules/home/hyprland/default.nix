{ ... }:

{
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./input.nix
    ./looknfeel.nix
    ./monitors.nix
    ./scripts.nix
    ./windows.nix

    ./bindings/clipboard.nix
    ./bindings/media.nix
    ./bindings/tiling.nix
    ./bindings/tiling-v2.nix
    ./bindings/utilities.nix
  ];
}
