{ pkgs, ... }:

{
  imports = [
    ./config.nix
    ./elephant.nix
    ./service.nix
    ./theme.nix
  ];

  home.packages = [
    pkgs.walker
    pkgs.elephant
  ];
}
