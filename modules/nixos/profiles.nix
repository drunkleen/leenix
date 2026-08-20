{ ... }:

# LEENIX profile composition — Core-owned import of every reusable profile.
#
# External instances never import profile files; they only set typed flags:
#
#   leenix.profiles.base.enable = true;
#   leenix.profiles.desktop.enable = true;
#   ...
#
# This module is the single source of profile imports. Each imported profile
# gates its own behavior on `leenix.profiles.<name>.enable` (via the typed
# option tree from core/options.nix), so importing all profiles once is inert
# until a flag is turned on. This keeps profile implementation and user-selected
# policy as one consistent model — no double source of truth.
{
  imports = [
    # Existing reusable profiles. The `config = lib.mkIf ...` inside each is the
    # sole enable gate; no conditional import is needed here.
    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../profiles/laptop.nix
    ../../profiles/gaming.nix
    ../../profiles/development.nix
    ../../profiles/applications.nix
    ../../profiles/cybersecurity.nix
    ../../profiles/ai.nix
  ];
}
