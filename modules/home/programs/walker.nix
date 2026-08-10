{ pkgs, ... }:

{
  home.packages = [
    pkgs.walker
    pkgs.elephant
  ];
}
