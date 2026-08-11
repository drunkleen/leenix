{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg-full
    mediainfo
    playerctl
    yt-dlp
  ];
}
