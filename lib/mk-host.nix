{ inputs }:
{ hostName }:

let
  inherit (inputs)
    agenix
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
    agenix.nixosModules.default
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    ../hosts/${hostName}

    {
      home-manager = import ./mk-home.nix { inherit inputs; } { inherit vars; };
    }
  ];
}
