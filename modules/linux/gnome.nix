{ config, pkgs, lib, ... }:

{
  imports = [
    ../../packages/gnome/gnome.nix
    ../../packages/gnome-extensions/gnome-extensions.nix
    ../../packages/gnome-network-displays/gnome-network-displays.nix
  ];
}