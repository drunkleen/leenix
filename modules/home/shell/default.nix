{ ... }:

{
  imports = [
    ../terminal/kitty.nix
    ../terminal/tmux
    ../terminal/yazi.nix
    ./zsh.nix
    ./starship.nix
    ./tools.nix
    ./aliases
    ./functions
  ];
}
