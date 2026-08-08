{ ... }:

{
  imports = [
    ../../modules/home
  ];

  home.username = "snape";
  home.homeDirectory = "/home/snape";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
