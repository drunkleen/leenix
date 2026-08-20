{ ... }:

# LEENIX boot/visual composition layer (Core-owned).
#
# The reusable boot stack, imported ONCE by the canonical mkInstance constructor
# for every instance. Each component is inert until its typed leenix.boot.*
# option opts in:
#   - leenix.boot.loader          -> selects the backend (limine / systemd-boot)
#   - leenix.boot.kernel.*        -> kernel ownership policy
#   - leenix.boot.plymouth.enable -> Plymouth splash
#   - leenix.boot.visual.enable   -> quiet/verbose boot visuals
#
# Instances never import these internal boot paths directly; they only set the
# typed options. Machine-specific boot content (extra boot entries, hardware
# config) lives in the instance.
{
  imports = [
    ./kernel.nix
    ./limine
    ./plymouth.nix
    ./systemd-boot.nix
    ./visual.nix
  ];
}