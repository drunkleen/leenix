{ lib }:

{
  nixpkgs,
  inputs,
  hostPath,
}:

let
  defaultVariables = import "${hostPath}/variables.nix";

  # Machine-local declarative policy overrides (menu-editable: timezone,
  # locale, DNS). Optional, gitignored, persists across reboot, and is merged
  # recursively over the version-controlled host defaults.
  #
  # local.nix is NOT part of the git-flake source, so it is read from the
  # source checkout via LEENIX_SRC (impure). In pure evaluation (nix flake
  # check) the variable is empty and only the version-controlled defaults are
  # used. leenix-config / leenix-rebuild run with --impure and
  # export LEENIX_SRC so the override is applied at build time.
  srcPath = builtins.getEnv "LEENIX_SRC";
  hostName = baseNameOf hostPath;
  localPath = if srcPath == "" then "" else "${srcPath}/hosts/${hostName}/local.nix";

  localOverride =
    if srcPath != "" && builtins.pathExists localPath then
      import localPath
    else
      { };

  variables = lib.recursiveUpdate defaultVariables localOverride;
in

nixpkgs.lib.nixosSystem {
  system = variables.architecture;

  specialArgs = {
    inherit inputs variables;
  };

  modules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    hostPath
  ];
}
