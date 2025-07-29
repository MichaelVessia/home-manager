{ config, pkgs, lib, ... }:

{
  # macOS-specific system settings and keybindings
  
  # macOS defaults (these would need to be applied via defaults write commands)
  home.activation.macosDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ "$(uname)" == "Darwin" ]]; then
      # Show battery percentage
      $DRY_RUN_CMD defaults write com.apple.menuextra.battery ShowPercent -bool true
      
      # Disable natural scrolling (set to true for default macOS behavior)
      $DRY_RUN_CMD defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
      
      # Enable tap to click
      $DRY_RUN_CMD defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
      $DRY_RUN_CMD defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
      
      # Show all filename extensions
      $DRY_RUN_CMD defaults write NSGlobalDomain AppleShowAllExtensions -bool true
      
      # Disable auto-correct
      $DRY_RUN_CMD defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
      
      # Set a fast key repeat rate
      $DRY_RUN_CMD defaults write NSGlobalDomain KeyRepeat -int 2
      $DRY_RUN_CMD defaults write NSGlobalDomain InitialKeyRepeat -int 15
      
      # Restart affected apps
      $DRY_RUN_CMD killall Finder || true
      $DRY_RUN_CMD killall SystemUIServer || true
    fi
  '';
  
  # macOS-specific environment variables
  home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
    # Add any macOS-specific environment variables here
  };
}