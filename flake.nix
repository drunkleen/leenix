{
  description = "Leen's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, ... }:
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
        home-manager.nixosModules.home-manager
        ./hosts/tuf-f15

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
            inherit vars;
          };

          home-manager.users.${vars.username} =
            import ./home/${vars.username};
        }
      ];
    };
  };
}
