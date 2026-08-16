{ pkgs, ... }:

# Legacy desktop-app package-install ownership.
#
# MIGRATED to modules/nixos/applications/catalog.nix (single package owner):
#   discord, spotify, signal-desktop, telegram-desktop, thunderbird,
#   bitwarden-desktop
#
# These are now installed exclusively by the applications catalog on the host
# boolean. Any Home Manager configuration/settings/theme for these applications
# lives in its own module and is untouched here.
{
  home.packages = with pkgs; [
  ];
}
