{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./lazygit.nix
    ./tealdeer.nix
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
    tree
    unzip
    yq-go
    zip
  ];

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
