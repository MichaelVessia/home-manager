{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-network-displays
  ];
}