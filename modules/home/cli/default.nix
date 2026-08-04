{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    eza
    fd
    fzf
    jq
    ripgrep
    tree
    unzip
    yazi
    zip
  ];


  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}
