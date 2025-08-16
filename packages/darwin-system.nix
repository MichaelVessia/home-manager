{ config, pkgs, lib, ... }:

{
  # macOS-specific system settings and keybindings
  
  # macOS defaults (these would need to be applied via defaults write commands)
  home.activation.macosDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ "$(uname)" == "Darwin" ]]; then
      # Show battery percentage
      $DRY_RUN_CMD /usr/bin/defaults write com.apple.menuextra.battery ShowPercent -bool true
      
      # Hide dock by default to save screen real estate
      $DRY_RUN_CMD /usr/bin/defaults write com.apple.dock autohide -bool true
      $DRY_RUN_CMD /usr/bin/defaults write com.apple.dock autohide-time-modifier -float 0.5
      
      # Disable natural scrolling (set to true for default macOS behavior)
      $DRY_RUN_CMD /usr/bin/defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
      
      # Enable tap to click
      $DRY_RUN_CMD /usr/bin/defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
      $DRY_RUN_CMD /usr/bin/defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
      
      # Show all filename extensions
      $DRY_RUN_CMD /usr/bin/defaults write NSGlobalDomain AppleShowAllExtensions -bool true
      
      # Disable auto-correct
      $DRY_RUN_CMD /usr/bin/defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
      
      # Set a fast key repeat rate
      $DRY_RUN_CMD /usr/bin/defaults write NSGlobalDomain KeyRepeat -int 2
      $DRY_RUN_CMD /usr/bin/defaults write NSGlobalDomain InitialKeyRepeat -int 15
      
      # Disable default macOS screenshot shortcuts (since we use Shottr)
      # Disable Cmd+Shift+3 (capture entire screen)
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set ':AppleSymbolicHotKeys:28:enabled' 'false'" "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || true
      # Disable Cmd+Shift+4 (capture selected area)
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set ':AppleSymbolicHotKeys:29:enabled' 'false'" "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || true
      # Disable Cmd+Shift+5 (screenshot and recording options)
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set ':AppleSymbolicHotKeys:184:enabled' 'false'" "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || true
      # Disable Ctrl+Cmd+Shift+3 (copy entire screen to clipboard)
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set ':AppleSymbolicHotKeys:30:enabled' 'false'" "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || true
      # Disable Ctrl+Cmd+Shift+4 (copy selected area to clipboard)
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set ':AppleSymbolicHotKeys:31:enabled' 'false'" "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || true
      
      # Disable Spotlight Command+Space hotkey to allow Raycast to use it
      # Note: Raycast must be configured manually via GUI - it doesn't support CLI configuration
      # After running this config, manually set Raycast hotkey to Command+Space in Raycast Preferences
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set ':AppleSymbolicHotKeys:64:enabled' 'false'" "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || {
        # Create the key structure if it doesn't exist (fresh macOS installs)
        $DRY_RUN_CMD /usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" \
          -c "Add :AppleSymbolicHotKeys:64:enabled bool false" \
          -c "Add :AppleSymbolicHotKeys:64:value:parameters array" \
          -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 65535" \
          -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 49" \
          -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 1048576" 2>/dev/null || true
      }
      
      # Manual Raycast Setup Required:
      # 1. Open Raycast and go to Preferences (Cmd+,)
      # 2. Set main hotkey to Command+Space
      # 3. Configure app switching hotkeys:
      #    - Cmd+1 for Ghostty (com.mitchellh.ghostty)
      #    - Cmd+2 for Brave Browser (com.brave.Browser) 
      #    - Cmd+3 for Obsidian (md.obsidian)
      #    - Cmd+4 for Slack (com.tinyspeck.slackmacgap)
      
      # Restart affected apps
      $DRY_RUN_CMD /usr/bin/killall Finder || true
      $DRY_RUN_CMD /usr/bin/killall SystemUIServer || true
      $DRY_RUN_CMD /usr/bin/killall Dock || true
    fi
  '';
  
  # macOS-specific environment variables
  home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
    # Add any macOS-specific environment variables here
  };
}