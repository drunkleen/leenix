{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./secrets.nix
    ../../profiles/workstation.nix
  ];

  system.stateVersion = "26.05";
}
