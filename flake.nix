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

    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      disko,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} = {
        statix = pkgs.runCommand "statix-check" { nativeBuildInputs = [ pkgs.statix ]; } ''
          cd ${self}
          statix check --ignore 'hosts/tuf-f15/hardware-configuration.nix' .
          touch $out
        '';

        deadnix = pkgs.runCommand "deadnix-check" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          cd ${self}
          deadnix --fail --exclude hosts/tuf-f15/hardware-configuration.nix .
          touch $out
        '';

        branding = pkgs.runCommand "branding-check" { nativeBuildInputs = [ pkgs.ripgrep ]; } ''
          cd ${self}
          legacy_name="omar""chy"

          if rg --ignore-case "$legacy_name" .; then
            echo "Forbidden legacy branding found in file contents" >&2
            exit 1
          fi

          if rg --files . | rg --ignore-case "$legacy_name"; then
            echo "Forbidden legacy branding found in a file path" >&2
            exit 1
          fi

          touch $out
        '';

        tuf-f15 = self.nixosConfigurations.tuf-f15.config.system.build.toplevel;
      };

      nixosConfigurations.tuf-f15 =
        let
          vars = import ./hosts/tuf-f15/variables.nix;
        in
        nixpkgs.lib.nixosSystem {
          inherit (vars) system;

          specialArgs = {
            inherit vars inputs;
          };

          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ./hosts/tuf-f15

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit vars inputs;
                };

                users.${vars.username} = import ./home/${vars.username};
              };
            }
          ];
        };
    };
}
