{ ... }:

# Cybersecurity helper scripts. Installed only when the cybersecurity profile
# is enabled (leenix.profiles.cybersecurity.enable). Not part of the universal base.
# The full tool catalog itself is NixOS/system-owned; these helpers only add
# capability-aware convenience/launch scripts.
{
  imports = [
    ./leenix-cyber-external.nix
    ./leenix-wordlists.nix
  ];
}
