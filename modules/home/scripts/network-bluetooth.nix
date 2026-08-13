{ ... }:

{
  # Bluetooth capability: launcher/control. Installed only when the host
  # declares the Bluetooth hardware capability (variables.hardware.bluetooth).
  imports = [
    ./leenix-launch-bluetooth.nix
    ./leenix-restart-bluetooth.nix
  ];
}
