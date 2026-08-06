{ inputs }:
{ hostName }:

let
  inherit (inputs)
    disko
    home-manager
    nixpkgs
    ;

  vars = import ../hosts/${hostName}/variables.nix;
in
nixpkgs.lib.nixosSystem {
  inherit (vars) system;

  specialArgs = {
    inherit vars inputs;
  };

  modules = [
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    ../hosts/${hostName}

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = {
          inherit vars inputs;
        };

        users.${vars.username} = import ../home/${vars.username};
      };
    }
  ];
}
