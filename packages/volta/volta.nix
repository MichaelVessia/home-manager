{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    volta
  ];
}