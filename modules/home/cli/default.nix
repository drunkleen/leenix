{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    libfido2
    openssh
    usbutils
    yubikey-manager
  ];
}
