{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    feh
    vlc
    yt-dlp
  ];
}