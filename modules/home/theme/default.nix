{ lib, themeMode, ... }:

assert lib.assertMsg (
  themeMode == "dark" || themeMode == "light"
) "leenix.theme.mode must be 'dark' or 'light'";

{
  imports = [
    ./gtk.nix
    ./qt.nix
  ];
}
