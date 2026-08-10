{
  # Script composition: only safe, NixOS-relevant scripts are activated by
  # default. legacy-arch.nix and dangerous.nix are kept in the repository but
  # deliberately NOT imported here.
  imports = [
    ./portable.nix
    ./nixos.nix
  ];
}
