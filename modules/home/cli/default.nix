{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    btop
    dust
    duf
    eza
    fd
    fzf
    jq
    lazygit
    p7zip
    ripgrep
    tealdeer
    tree
    unzip
    yazi
    yq-go
    zip
  ];


  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
