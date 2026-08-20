{
  lib,
  leenix,
  ...
}:

let
  desktopCap = leenix.profiles.desktop.enable;
  hyprlandCap = leenix.desktop.hyprland.enable;
in

{
  imports =
    # Binary ownership for AI coding agents moved to the NixOS AI catalog
    # (modules/nixos/ai). Config/theme ownership lives in modules/home/ai.
    [ ]
    # Desktop-only programs: app launcher (Walker) and gaming overlay.
    ++ lib.optionals desktopCap [
      ./mangohud.nix
      ./walker
    ]
    # The universal session manager (uwsm) only makes sense under Hyprland.
    ++ lib.optionals hyprlandCap [
      ./uwsm.nix
    ];
}
