{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _7zz
    btop
    gnumake
    libfido2
    openssh
    ripgrep
    terminaltexteffects
    usbutils
    yubikey-manager
  ];
}
