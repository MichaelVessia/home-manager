{ config, pkgs, ... }:

{
  imports = [
    ../../packages/brave/brave.nix
    ../../packages/obsidian/obsidian.nix
    ../../packages/spotify/spotify.nix
  ];
}