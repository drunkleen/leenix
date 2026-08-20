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
      self,
      nixpkgs,
      home-manager,
      disko,
      leenfetch,
      ...
    }:

    let
      # Canonical LEENIX package overlay (see overlays/default.nix).
      leenixOverlay = (import ./overlays/default.nix) { inherit leenfetch; };

      # Public external-instance constructor, closed over Core's own inputs.
      mkInstance = import ./lib/mkInstance.nix {
        inherit nixpkgs home-manager disko;
        overlay = leenixOverlay;
      };

      # Public library: the canonical mkInstance constructor.
      leenixLib = import ./lib {
        lib = nixpkgs.lib;
        inherit mkInstance;
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      # Public library: mkInstance (external path, closed over Core's own inputs so
      # callers pass only instance concerns). The legacy mkHost adapter was
      # removed in Phase 9F.3B; every instance is built through mkInstance.
      lib = leenixLib;

      # Canonical overlay output (replaces the former non-standard `nixpkgs`
      # output; nothing consumed `nixpkgs.overlays` directly).
      overlays.default = leenixOverlay;

      # Public composed modules for advanced/composable consumers and testing.
      # The normal generated instance uses leenix.lib.mkInstance instead and
      # sets typed leenix.* options; these modules are constructor internals
      # exposed for advanced use.
      nixosModules = {
        options = { ... }: { imports = [ ./modules/nixos/core/options.nix ]; };
        profiles = { ... }: { imports = [ ./modules/nixos/profiles.nix ]; };
        homeManager = { ... }: { imports = [ ./modules/nixos/home-manager.nix ]; };
        diskoIntegration = { ... }: { imports = [ ./modules/nixos/disk/default.nix ]; };
      };

      packages.x86_64-linux.leenfetch =
        nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/leenfetch.nix {
          src = leenfetch;
        };

      # External-consumer fixture public-contract check. Evaluates the neutral
      # fixture policy through mkInstance (avoids a Core <-> fixture recursion).
      checks."x86_64-linux"."generated-desktop" =
        import ./tests/fixtures/generated-desktop/check.nix {
          inherit mkInstance;
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          lib = nixpkgs.lib;
        };
    };
}
