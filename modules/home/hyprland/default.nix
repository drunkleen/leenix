{ ... }:

{
  imports = [
    ./autostart.nix
    ./env.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./input.nix
    ./looknfeel.nix
    ./monitors.nix
    ./scripts.nix
    ./windows.nix

    ./bindings/general.nix
    ./bindings/clipboard.nix
    ./bindings/media.nix
    ./bindings/tiling.nix
    ./bindings/utilities.nix
  ];
}
