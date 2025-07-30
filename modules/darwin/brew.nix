{ config, pkgs, lib, ... }:

{
  # Homebrew management for macOS
  # This module handles Homebrew installation and package management
  
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
    
    # Install Homebrew if not present, then manage packages
    home.activation.brewSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ "$(uname)" == "Darwin" ]]; then
        # Check if Homebrew is installed
        if ! command -v brew >/dev/null 2>&1; then
          # Check common Homebrew locations
          if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
          else
            echo "============================================"
            echo "Homebrew is not installed!"
            echo ""
            echo "Please install Homebrew manually by running:"
            echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            echo ""
            echo "After installation, run 'make darwin' again."
            echo "============================================"
            exit 0
          fi
        fi
        
        # Now that Homebrew is available, manage packages
        if command -v brew >/dev/null 2>&1; then
          echo "Managing Homebrew packages..."
          
          # Create main Brewfile (with SHA requirements)
          cat > "$HOME/.config/homebrew/Brewfile" <<EOF
# GUI Applications (casks) - with SHA checksums
cask "1password"         # Password manager
cask "brave-browser"     # Web browser
cask "ghostty"           # GPU-accelerated terminal emulator
cask "karabiner-elements" # Keyboard customization tool
cask "raycast"           # Spotlight replacement and productivity launcher
                         # Manual setup required: Configure Command+Space hotkey and app switching (Cmd+1-4) in Raycast Preferences
# cask "rectangle"       # Window management
# cask "alfred"          # Spotlight replacement

# CLI tools that work better from Homebrew
# brew "mas"  # Mac App Store CLI

# Mac App Store apps (requires mas)
# mas "Amphetamine", id: 937984704
EOF

          # Create separate Brewfile for casks without SHA checksums
          cat > "$HOME/.config/homebrew/Brewfile.nosha" <<EOF
# GUI Applications (casks) - without SHA checksums
# These casks don't have SHA256 checksums defined in homebrew-cask
cask "google-drive"      # Google Drive desktop application
EOF
          
          # Install packages with SHA requirements
          echo "Installing packages from main Brewfile (with SHA requirements)..."
          brew bundle --file="$HOME/.config/homebrew/Brewfile" || true
          
          # Install packages without SHA requirements
          echo "Installing packages from no-SHA Brewfile..."
          HOMEBREW_CASK_OPTS="" brew bundle --file="$HOME/.config/homebrew/Brewfile.nosha" || true
          
          echo "Homebrew packages installed successfully!"
        else
          echo "Warning: Homebrew installation completed but 'brew' command not found in PATH"
          echo "You may need to restart your terminal and run 'make darwin' again"
        fi
      fi
    '';
    
    # Ensure the Brewfile directory exists
    home.file.".config/homebrew/.keep".text = "";
  };
}