{ config, pkgs, lib, ... }:

{
  imports = [
    ./gnome.nix
    ./apparmor.nix
    ./packages.nix
  ];
}