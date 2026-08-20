{ leenix, ... }:

{
  imports = [
    {
      zathura = ./zathura.nix;
    }.${leenix.desktop.documentViewer}
  ];
}
