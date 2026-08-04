{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos/boot
    ../../modules/nixos/networking
    ../../modules/nixos/storage
    ../../modules/nixos/users
    ../../modules/nixos/services
  ];

  system.stateVersion = "26.05";
}
