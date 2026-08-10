{
  description = "LEENIX - Modular declarative NixOS framework";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:

    let
      leenixLib = import ./lib {
        inherit (nixpkgs) lib;
      };
    in
    {
      nixosConfigurations = {
        tuf-f15 = leenixLib.mkHost {
          inherit nixpkgs inputs;
          hostPath = ./hosts/tuf-f15;
        };
      };
    };
}
