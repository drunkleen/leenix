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

    leenfetch = {
      url = "github:drunkleen/leenfetch";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      leenfetch,
      ...
    }:

    let
      leenixLib = import ./lib {
        inherit (nixpkgs) lib;
      };

      # LEENIX package overlay: makes pkgs.leenfetch available to every profile
      # and module (base About tool, home scripts, etc.).
      leenixOverlay = final: prev: {
        leenfetch = final.callPackage ./packages/leenfetch.nix {
          src = leenfetch;
        };
        # Patched HyprMon: skip rewriting the (possibly immutable, nix-managed)
        # main hyprland.lua when the managed `require("hyprmon")` include already
        # exists. See packages/hyprmon/skip-unchanged-config-write.patch.
        hyprmon = prev.hyprmon.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./packages/hyprmon/skip-unchanged-config-write.patch ];
        });
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      nixpkgs.overlays = [ leenixOverlay ];

      packages.x86_64-linux.leenfetch =
        nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/leenfetch.nix {
          src = leenfetch;
        };

      nixosConfigurations = {
        tuf-f15 = leenixLib.mkHost {
          inherit nixpkgs inputs;
          hostPath = ./hosts/tuf-f15;
          overlays = [ leenixOverlay ];
        };
      };
    };
}
