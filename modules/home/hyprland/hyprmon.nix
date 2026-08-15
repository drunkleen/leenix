{
  pkgs,
  ...
}:

{
  # HyprMon is the mutable monitor-layout owner for Hyprland. It edits
  # ~/.config/hypr/hyprmon.lua (loaded by hyprland.nix); no other monitor
  # rule file is mutable. Installed automatically with the Hyprland capability.
  home.packages = with pkgs; [
    hyprmon
    wtype
  ];
}
