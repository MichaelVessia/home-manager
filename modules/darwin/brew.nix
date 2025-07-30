{ config, pkgs, lib, ... }:

let
  # Organize packages by category
  brewPackages = {
    # GUI Applications (casks) - with SHA checksums
    casksWithSha = [
      { name = "1password"; description = "Password manager"; }
      { name = "brave-browser"; description = "Web browser"; }
      { name = "ghostty"; description = "GPU-accelerated terminal emulator"; }
      { name = "karabiner-elements"; description = "Keyboard customization tool"; }
      { name = "raycast"; description = "Spotlight replacement and productivity launcher"; note = "Manual setup required: Configure Command+Space hotkey and app switching (Cmd+1-4) in Raycast Preferences"; }
      { name = "shottr"; description = "Screenshot tool"; }
      { name = "superwhisper"; description = "Speech-to-text"; }
      { name = "jordanbaird-ice"; description = "Status bar management"; }
      { name = "figma"; description = "Design"; }
      { name = "claude"; description = "AI"; }
      { name = "chatgpt"; description = "AI"; }
    ];
    
    # Disabled casks (kept for reference)
    disabledCasks = [
      # { name = "rectangle"; description = "Window management"; }
      # { name = "alfred"; description = "Spotlight replacement"; }
    ];
    
    # GUI Applications (casks) - without SHA checksums
    casksNoSha = [
      { name = "google-drive"; description = "Google Drive desktop application"; }
    ];
    
    # CLI tools that work better from Homebrew
    brews = [
      { name = "mas"; description = "Mac App Store CLI"; }
    ];
    
    # Mac App Store apps (requires mas)
    masApps = [
      { name = "Xcode"; id = 497799835; note = "Large download (~10GB), may take a long time"; }
      # { name = "Amphetamine"; id = 937984704; }
    ];
  };
  
  # Helper function to format a cask entry
  formatCask = cask: 
    if cask ? note
    then ''cask "${cask.name}" # ${cask.description}\n                         # ${cask.note}''
    else ''cask "${cask.name}" # ${cask.description}'';
  
  # Helper function to format a brew entry
  formatBrew = brew: ''brew "${brew.name}" # ${brew.description}'';
  
  # Helper function to format a mas entry
  formatMas = app: 
    if app ? note
    then ''# ${app.note}\nmas "${app.name}", id: ${toString app.id}''
    else ''mas "${app.name}", id: ${toString app.id}'';
  
  # Generate Brewfile content
  mainBrewfileContent = ''
    # GUI Applications (casks) - with SHA checksums
    ${lib.concatMapStringsSep "\n" formatCask brewPackages.casksWithSha}
    ${lib.concatMapStringsSep "\n" (cask: "# ${formatCask cask}") brewPackages.disabledCasks}
    
    # CLI tools that work better from Homebrew
    ${lib.concatMapStringsSep "\n" formatBrew brewPackages.brews}
    
    # Mac App Store apps (requires mas)
    ${lib.concatMapStringsSep "\n" formatMas brewPackages.masApps}
  '';
  
  noshaBrewfileContent = ''
    # GUI Applications (casks) - without SHA checksums
    # These casks don't have SHA256 checksums defined in homebrew-cask
    ${lib.concatMapStringsSep "\n" formatCask brewPackages.casksNoSha}
  '';

in
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
    
    # Write Brewfiles as home-manager managed files
    home.file.".config/homebrew/Brewfile".text = mainBrewfileContent;
    home.file.".config/homebrew/Brewfile.nosha".text = noshaBrewfileContent;
    
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
          
          # Install packages with SHA requirements
          echo "Installing packages from main Brewfile (with SHA requirements)..."
          brew bundle --verbose --file="$HOME/.config/homebrew/Brewfile" || true
          
          # Install packages without SHA requirements
          echo "Installing packages from no-SHA Brewfile..."
          HOMEBREW_CASK_OPTS="" brew bundle --verbose --file="$HOME/.config/homebrew/Brewfile.nosha" || true
          
          echo "Homebrew packages installed successfully!"
          
          # Show mas installation status
          echo ""
          echo "Mac App Store installations:"
          if command -v mas >/dev/null 2>&1; then
            echo "Currently installed Mac App Store apps:"
            mas list || echo "No apps installed yet"
            echo ""
            echo "Note: Mac App Store apps (like Xcode) can take a long time to download."
            echo "You can check download progress in the Mac App Store app."
            echo "To install manually, run: mas install 497799835"
          fi
        else
          echo "Warning: Homebrew installation completed but 'brew' command not found in PATH"
          echo "You may need to restart your terminal and run 'make darwin' again"
        fi
      fi
    '';
  };
}
