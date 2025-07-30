{ config, pkgs, ... }:

{
  imports = [
    ../../packages/obsidian/obsidian.nix
    ../../packages/spotify/spotify.nix
  ];
}