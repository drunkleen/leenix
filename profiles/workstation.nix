{
  imports = [
    ./core.nix
    ../modules/nixos/boot
    ./desktop.nix
    ./laptop.nix
    ../modules/nixos/networking
    ../modules/nixos/security
    ../modules/nixos/services
    ../modules/nixos/storage
    ../modules/nixos/users
  ];
}
