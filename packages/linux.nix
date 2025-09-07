{ config, pkgs, lib, ... }:

{
  imports = [
    # Linux-specific packages
    ./nixgl/nixgl.nix
    ./signal-desktop/signal-desktop.nix
    ./bitwarden/bitwarden.nix
    ./tailscale/tailscale.nix
    ./syncthing/syncthing.nix
    ./media/media.nix
    ./brave/brave.nix
    ./ultrawhisper/ultrawhisper.nix
    
    # GNOME-related packages
    ./gnome/gnome.nix
    ./gnome-extensions/gnome-extensions.nix
    ./gnome-network-displays/gnome-network-displays.nix
    
    # AppArmor support
    ./apparmor/apparmor-profiles.nix

    # Stuff for the kids
    #./kids/kids.nix

    # Entertainment
    ./steam/steam.nix
  ];
  
  home.packages = with pkgs; [
    # Linux-specific system tools
    xsel # clipboard manager
    
    # Playwright dependencies - install playwright with system dependencies
    playwright-driver
    playwright
  ];
}
