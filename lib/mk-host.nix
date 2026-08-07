{ inputs, self }:
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
    inherit vars inputs self;
  };

  modules = [
    agenix.nixosModules.default
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    ../hosts/${hostName}

    {
      home-manager = import ./mk-home.nix { inherit inputs self; } { inherit vars; };
    }
  ];
}
