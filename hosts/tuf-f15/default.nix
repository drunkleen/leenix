{ vars, ... }:

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

  networking.hostName = vars.hostname;

  time.timeZone = vars.timezone;

  i18n.defaultLocale = vars.locale;

  console.keyMap = vars.keymap;

  system.stateVersion = "26.05";
}
