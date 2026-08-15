# Throwaway flake for the base/server isolation test. NOT part of the LEENIX
# host fleet; exists only to prove that a base-only host receives no
# desktop/hyprland/laptop/network-capability scripts.
{
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
    leenfetch = {
      url = "github:drunkleen/leenfetch";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs, leenfetch, ... }:
    let
      leenixLib = import ../../lib { inherit (nixpkgs) lib; };
      leenixOverlay = final: prev: {
        leenfetch = final.callPackage ../../packages/leenfetch.nix {
          src = leenfetch;
        };
      };
    in
    {
      nixosConfigurations.basehost = leenixLib.mkHost {
        inherit nixpkgs inputs;
        hostPath = ./.;
        overlays = [ leenixOverlay ];
      };
    };
}
