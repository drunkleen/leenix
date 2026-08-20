{ lib, mkInstance }:

# LEENIX public library surface.
#
#   mkInstance  = canonical external-instance constructor (wired in flake.nix;
#                 closed over nixpkgs/home-manager/disko/overlay).
#
# The legacy `mkHost` in-tree host-layout adapter was removed in Phase 9F.3B;
# every instance (production tuf-f15 and generated fixtures alike) is built
# directly through `mkInstance` from typed `leenix.*` policy.
{
  inherit mkInstance;
}