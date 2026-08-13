{ pkgs, ... }:

{
  imports = [
    ./media.nix
    ./music.nix
  ];

  home.packages = with pkgs; [
    _7zz
    gnumake
    libfido2
    openssh
    terminaltexteffects
    usbutils
    yubikey-manager
  ];
}
