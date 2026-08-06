{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./lazygit.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    btop
    dust
    duf
    eza
    fd
    fzf
    jq
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
