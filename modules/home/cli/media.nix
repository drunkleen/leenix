{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg-full
    mediainfo
    yt-dlp
  ];
}
