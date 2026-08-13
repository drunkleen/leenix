{ pkgs, ... }:

{
  # Binary ownership: the canonical terminal set (zsh, tmux, neovim, yazi,
  # eza, bat, fzf, zoxide, ripgrep, fd, jq, btop, …) lives in NixOS base
  # (profiles/base.nix). Home Manager owns only config and shell integration.
  home.packages = with pkgs; [
    starship
    bc
    iproute2
    xdg-utils
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
