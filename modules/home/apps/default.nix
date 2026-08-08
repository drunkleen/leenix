{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam
    discord
    spotify
    signal-desktop
    thunderbird
  ];
}
