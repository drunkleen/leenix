{ lib }:

{
  mkHost = import ./mkHost.nix {
    inherit lib;
  };
}
