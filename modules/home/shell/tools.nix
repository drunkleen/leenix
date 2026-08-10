{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    starship
    bat
    bc
    curl
    eza
    fzf
    iproute2
    jq
    xdg-utils
    yazi
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
