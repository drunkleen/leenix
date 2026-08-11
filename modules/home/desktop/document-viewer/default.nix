{ documentViewer, ... }:

{
  imports = [
    {
      zathura = ./zathura.nix;
    }.${documentViewer}
  ];
}
