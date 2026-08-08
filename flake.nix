{
  description = "Leenix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      systemConfig = import ./system/default.nix;

      boot = import ./system/boot {
        inherit pkgs systemConfig;
      };

      security = import ./system/security {
        inherit pkgs systemConfig;
      };
    in
    {
      homeConfigurations."snape@hogwarts" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home/snape/default.nix
          ];
        };

      packages.${system} =
        boot.packages
        // security.packages;

      apps.${system} =
        boot.apps
        // security.apps;
    };
}
