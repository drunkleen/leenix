{ lib, leenix, ... }:

assert lib.assertMsg (
  leenix.theme.mode == "dark" || leenix.theme.mode == "light"
) "leenix.theme.mode must be 'dark' or 'light'";

{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./locale.nix
    ./qt.nix
  ];
}
