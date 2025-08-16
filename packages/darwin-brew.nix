{ config, pkgs, lib, ... }:

{
  # Homebrew environment configuration for Home Manager
  # Package management is now handled by nix-darwin system configuration
  
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Add Homebrew to PATH
    home.sessionPath = [
      "/opt/homebrew/bin"  # Apple Silicon
      "/usr/local/bin"     # Intel Mac
    ];
    
    # Homebrew environment variables
    home.sessionVariables = {
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1";
      HOMEBREW_CASK_OPTS = "--require-sha";
    };
    
    # Create homebrew config directory
    home.file.".config/homebrew/.keep".text = "";
  };
}