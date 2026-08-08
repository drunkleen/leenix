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
    variables = import ./system/variables.nix;

    system = variables.system;
    pkgs = nixpkgs.legacyPackages.${system};

    systemConfig = import ./system/default.nix;

    boot = import ./system/boot {
      inherit pkgs systemConfig variables;
    };

    security = import ./system/security {
      inherit pkgs systemConfig variables;
    };
    in
    {
      homeConfigurations."${variables.user.username}@${variables.host.hostname}" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit variables;
          };

          modules = [
            ./home/default.nix
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
