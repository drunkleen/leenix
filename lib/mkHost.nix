{ lib }:

{
  nixpkgs,
  inputs,
  hostPath,
}:

let
  variables = import "${hostPath}/variables.nix";
in

nixpkgs.lib.nixosSystem {
  system = variables.architecture;

  specialArgs = {
    inherit inputs variables;
  };

  modules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    hostPath
  ];
}
