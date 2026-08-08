{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    starship
    bat
    eza
    yazi
    fzf
    curl
    jq
    iproute2
    xdg-utils
    nautilus
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };
}
