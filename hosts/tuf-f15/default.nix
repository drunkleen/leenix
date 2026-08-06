{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../profiles/workstation.nix
  ];

  system.stateVersion = "26.05";
}
