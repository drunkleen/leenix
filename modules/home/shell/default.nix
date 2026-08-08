{ ... }:

{
  imports = [
    ../terminal/kitty.nix
    ./zsh.nix
    ./starship.nix
    ./tools.nix
    ./aliases
    ./functions
  ];
}
