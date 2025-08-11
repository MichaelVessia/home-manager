{ config, pkgs, lib, ... }:

{
  # System-level nix-darwin configuration
  # This handles Homebrew package management and system settings
  
  # Enable Homebrew management through nix-darwin
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    
    # CLI tools that work better from Homebrew
    brews = [
      "mas" # Mac App Store CLI
    ];
    
    # GUI Applications (casks) - with SHA checksums
    casks = [
      "1password"
      "brave-browser"
      "ghostty"
      "karabiner-elements"
      "raycast"
      "shottr"
      "superwhisper"
      "jordanbaird-ice"
      "figma"
      "claude"
      "chatgpt"
      "openlens"
      "yaak"
      "orbstack"
      # GUI Applications without SHA checksums
      "google-drive"
    ];
    
    # Mac App Store apps (requires mas)
    masApps = {
      "Xcode" = 497799835;
      "Amphetamine" = 937984704;
    };
  };
  
  # System configuration
  system = {
    stateVersion = 5; # Don't change this
    primaryUser = "michael.vessia"; # Required for homebrew and user-specific options
  };
  
  # Nix configuration - disabled because using Determinate Nix installer
  nix.enable = false;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Set up user environment
  users.users."michael.vessia" = {
    name = "michael.vessia";
    home = "/Users/michael.vessia";
  };
  
}