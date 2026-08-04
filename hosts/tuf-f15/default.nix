{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos/core
    ../../modules/nixos/boot
    ../../modules/nixos/networking
    ../../modules/nixos/users
    ../../modules/nixos/services
  ];
}
