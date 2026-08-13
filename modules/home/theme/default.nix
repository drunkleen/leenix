{ lib, themeMode, ... }:

assert lib.assertMsg (
  themeMode == "dark" || themeMode == "light"
) "leenix.theme.mode must be 'dark' or 'light'";

{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./locale.nix
    ./qt.nix
  ];
}
