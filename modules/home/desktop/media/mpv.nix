{ pkgs, ... }:

let
  mpv = pkgs.mpv.override {
    mpv-unwrapped = pkgs.mpv-unwrapped.override {
      ffmpeg = pkgs.ffmpeg-full;
    };
  };
in
{
  programs.mpv.enable = true;
  programs.mpv.package = mpv;

  programs.mpv.config = {
    hwdec = "auto-safe";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-media";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default media player (MPV).

        exec ${pkgs.uwsm}/bin/uwsm app -t scope -- ${mpv}/bin/mpv "$@"
      '';
    })
  ];

}
