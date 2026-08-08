{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    discord
    signal-desktop
    spotify
    steam
    thunderbird
  ];
}
