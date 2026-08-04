{
  description = "Leen's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }:
  {
    nixosConfigurations.tuf-f15 =
      let
        vars = import ./hosts/tuf-f15/variables.nix;
      in
    nixpkgs.lib.nixosSystem {
      system = vars.system;

      specialArgs = {
        inherit vars;
      };

      modules = [
        disko.nixosModules.disko
        ./hosts/tuf-f15
      ];
    };
  };
}
