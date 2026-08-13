{ ... }:

{
  # Canonical LEENIX Yazi configuration, shared across hosts. Kept headless-safe:
  # no GUI preview/open integrations are configured here (host/desktop modules
  # may layer those on separately). The yazi binary is guaranteed by NixOS base
  # (profiles/base.nix); Home Manager owns only config + zsh integration, so
  # package = null avoids duplicate package ownership.
  programs.yazi = {
    enable = true;
    package = null;
    enableZshIntegration = true;
  };
}
