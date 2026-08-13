{ ... }:

{
  imports = [
    ../terminal/kitty.nix
    ../terminal/tmux.nix
    ../terminal/yazi.nix
    ./zsh.nix
    ./starship.nix
    ./tools.nix
    ./aliases
    ./functions
  ];
}
