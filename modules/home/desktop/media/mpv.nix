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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
    "video/mpeg" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";
    "application/ogg" = "mpv.desktop";
    "audio/mpeg" = "mpv.desktop";
    "audio/flac" = "mpv.desktop";
    "audio/ogg" = "mpv.desktop";
    "audio/x-wav" = "mpv.desktop";
    "audio/mp4" = "mpv.desktop";
    "audio/aac" = "mpv.desktop";
  };
}
