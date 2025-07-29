{ config, pkgs, lib, ... }:

{
  imports = [
    ../../packages/nixgl/nixgl.nix
    ../../packages/signal-desktop/signal-desktop.nix
    ../../packages/bitwarden/bitwarden.nix
    ../../packages/tailscale/tailscale.nix
    ../../packages/syncthing/syncthing.nix
    ../../packages/media/media.nix
  ];
  
  home.packages = with pkgs; [
    xsel # clipboard manager (Linux-specific)
    kooha # screen recorder (Linux-specific)
    pinta # image editor
    ffmpeg # video/audio converter
  ];
}