{ mediaPlayer, ... }:

{
  imports = [
    {
      mpv = ./mpv.nix;
    }.${mediaPlayer}
  ];
}
