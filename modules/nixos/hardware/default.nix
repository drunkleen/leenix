{ ... }:

{
  imports = [
    ./cpu.nix
    ./firmware.nix
    ./audio.nix
    ./bluetooth.nix
    ./graphics.nix
    ./power.nix
    ./thermal.nix
    ./laptop
  ];
}
