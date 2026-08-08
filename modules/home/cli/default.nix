{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libfido2
    openssh
    usbutils
    yubikey-manager
  ];
}
