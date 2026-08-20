{ leenix, ... }:

{
  imports = [
    {
      imv = ./imv.nix;
    }.${leenix.desktop.imageViewer}
  ];
}
