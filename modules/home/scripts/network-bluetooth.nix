{ ... }:

{
  # Bluetooth capability: launcher/control. Installed only when the host
  # declares the Bluetooth hardware capability (leenix.hardware.bluetooth.enable).
  imports = [
    ./leenix-launch-bluetooth.nix
    ./leenix-restart-bluetooth.nix
  ];
}
