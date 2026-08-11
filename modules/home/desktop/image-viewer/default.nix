{ imageViewer, ... }:

{
  imports = [
    {
      imv = ./imv.nix;
    }.${imageViewer}
  ];
}
