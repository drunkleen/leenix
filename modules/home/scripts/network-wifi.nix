{ ... }:

{
  # Wi-Fi capability: launcher/control/powersave. Installed only when the host
  # declares the iwd networking capability (leenix.networking.iwd.enable).
  imports = [
    ./leenix-airplane.nix
    ./leenix-launch-wifi.nix
    ./leenix-restart-wifi.nix
    ./leenix-wifi-powersave.nix
  ];
}
