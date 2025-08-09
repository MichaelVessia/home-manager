{ config, pkgs, lib, ... }:

{
  imports = [
    ./shell.nix
    ./editor.nix
    ./git.nix
    ./development.nix
    ./terminal.nix
    ./apps.nix
    ./utilities.nix
    ./claude.nix
  ];
}