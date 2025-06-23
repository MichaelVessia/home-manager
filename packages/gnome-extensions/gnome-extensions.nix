{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.space-bar
  ];
}