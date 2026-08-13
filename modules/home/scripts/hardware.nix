{ ... }:

{
  # Generic hardware detection/helper scripts. Safe to install on any host that
  # runs the desktop or laptop profile.
  imports = [
    ./leenix-hw-dell-xps-haptic-touchpad.nix
    ./leenix-hw-dell-xps-oled.nix
    ./leenix-hw-framework16.nix
    ./leenix-hw-hybrid-gpu.nix
    ./leenix-hw-intel-ptl.nix
    ./leenix-hw-intel-sof.nix
    ./leenix-hw-intel.nix
    ./leenix-hw-match.nix
    ./leenix-hw-nvidia-gsp.nix
    ./leenix-hw-nvidia-without-gsp.nix
    ./leenix-hw-surface.nix
    ./leenix-hw-vulkan.nix
    ./leenix-toggle-hybrid-gpu.nix
  ];
}
