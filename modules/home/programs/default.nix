{
  lib,
  variables,
  ...
}:

let
  desktopCap = variables.profiles.desktop or false;
  hyprlandCap = variables.desktop.hyprland or false;
in

{
  imports = [ ./dev.nix ]
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
