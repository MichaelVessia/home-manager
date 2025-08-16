{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    
    # Linux-specific packages
    ./apparmor/apparmor-profiles.nix
    ./nixgl/nixgl.nix
    ./signal-desktop/signal-desktop.nix
    ./bitwarden/bitwarden.nix
    ./tailscale/tailscale.nix
    ./syncthing/syncthing.nix
    ./media/media.nix
    
    # GNOME desktop environment
    ./gnome/gnome.nix
    ./gnome-extensions/gnome-extensions.nix
    ./gnome-network-displays/gnome-network-displays.nix
  ];
  
  # Linux-specific packages that don't warrant their own files
  home.packages = with pkgs; [
    xsel # clipboard manager (Linux-specific)
    kooha # screen recorder (Linux-specific)
    pinta # image editor
    ffmpeg # video/audio converter
  ];
}