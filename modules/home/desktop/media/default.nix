{ leenix, ... }:

{
  imports = [
    {
      mpv = ./mpv.nix;
    }.${leenix.desktop.mediaPlayer}
  ];
}
