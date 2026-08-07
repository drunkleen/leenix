{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./secrets.nix
    ../../profiles/workstation.nix
  ];

  leenix.shell.enable = true;

  system.stateVersion = "26.05";
}
