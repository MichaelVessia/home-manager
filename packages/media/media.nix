{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    feh # image viewer
    vlc # video viewer
    yt-dlp # youtube downloader
    kooha # screen recorder
    pinta # image editor
  ];
}
