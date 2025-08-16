{ lib, config, pkgs, ... }:

let
  # Use actual system username on macOS, configured username on Linux
  username = if pkgs.stdenv.isDarwin then "michael.vessia" else "michaelvessia";
  platform = import ../lib/platform.nix { inherit lib pkgs; };
in
{
  imports = [
    # Common packages (from modules/common)
    ../packages/fish/fish.nix
    ../packages/nushell/nushell.nix
    ../packages/starship/starship.nix
    ../packages/neovim/neovim.nix
    ../packages/obsidian/obsidian.nix
    ../packages/spotify/spotify.nix
    ../packages/git/git.nix
    ../packages/mise/mise.nix
    ../packages/bun/bun.nix
    ../packages/cursor/cursor.nix
    ../packages/cheatsheets/default.nix
    ../packages/chezmoi/chezmoi.nix
    ../packages/lazygit/lazygit.nix
    ../packages/ghostty/ghostty.nix
    
    # Originally imported at host level
    ../packages/aws/aws.nix
    ../packages/claude-code/claude-code.nix
    ../packages/fonts/fonts.nix
    ../packages/home-manager/home-manager.nix
    ../packages/jira/jira.nix
    ../packages/karabiner/karabiner.nix
    ../packages/yazi/yazi.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  home = {
    inherit username;
    homeDirectory = platform.homeDirectory username;
    stateVersion = "25.05"; # Don't change this
  };
  
  # Enable font configuration
  fonts.fontconfig.enable = true;
  
  # Chezmoi activation
  home.activation.chezmoi = lib.hm.dag.entryAfter ["installPackages" "generateSshKey"] ''
    PATH="${pkgs.chezmoi}/bin:${pkgs.git}/bin:${pkgs.git-lfs}/bin:${pkgs.openssh}/bin:''${PATH}"

    $DRY_RUN_CMD chezmoi init git@github.com:MichaelVessia/dots.git
    $DRY_RUN_CMD chezmoi update -a
    $DRY_RUN_CMD chezmoi git status
  '';

  # Generate SSH key if it doesn't exist
  home.activation.generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      $DRY_RUN_CMD mkdir -p $HOME/.ssh
      $DRY_RUN_CMD chmod 700 $HOME/.ssh
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "michael.vessia@flosports.tv" -f $HOME/.ssh/id_ed25519 -N ""
      $DRY_RUN_CMD echo "SSH key generated! Add this public key to GitHub:"
      $DRY_RUN_CMD cat $HOME/.ssh/id_ed25519.pub
    fi
    
    # Ensure proper SSH permissions
    if [ -d "$HOME/.ssh" ]; then
      $DRY_RUN_CMD chmod 700 $HOME/.ssh
      $DRY_RUN_CMD chmod 600 $HOME/.ssh/id_ed25519 2>/dev/null || true
      $DRY_RUN_CMD chmod 644 $HOME/.ssh/id_ed25519.pub 2>/dev/null || true
      $DRY_RUN_CMD chmod 600 $HOME/.ssh/config 2>/dev/null || true
    fi
  '';

  # Disable problematic cleanup that uses GNU readlink -e (not available on macOS)
  home.activation.linkGeneration = lib.mkForce "";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Packages previously defined in modules
  home.packages = with pkgs; [
    # From modules/common/shell.nix
    atuin # Replacement for shell history
    
    # From modules/common/development.nix  
    gcc # C compiler
    gnumake # Build automation tool
    ast-grep # structured grep for code
    curl # data transfer tool
    wget # web file downloader
    jq # JSON processor
    unzip # archive extractor
    
    # From modules/common/git.nix
    gh # GitHub CLI
    git-lfs # Git Large File Storage
    lazygit # Git TUI
    delta # Syntax-highlighting pager for git diffs
    
    # From modules/common/utilities.nix
    # System monitoring
    htop # interactive process viewer (better than top)
    glances # Lists all processes + cpu/memory
    lsof # list open files and network connections
    
    # File utilities
    bat # syntax-highlighted file previews
    eza # modern ls replacement
    fd # fast file finder (better than find)
    fzf # fuzzy finder
    ripgrep # fast text search (better than grep)
    
    # Networking and security  
    nmap # network discovery and security auditing
    traceroute # trace network route to a host
    whois # domain lookup tool
    rsync # fast file synchronization tool
    openssh # SSH client/server
    gnupg # OpenPGP implementation
    
    # Archive and compression
    zip # zip compression
    p7zip # 7-Zip file archiver
    
    # Text processing
    tree # directory tree viewer
    watch # run commands repeatedly
    less # pager program
    
    # Development utilities
    direnv # automatic environment management
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # From modules/darwin/packages.nix - macOS-specific packages
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
    coreutils # Provides greadlink/readlink with GNU options (-e, -m) needed by Home Manager
  ];

  # Auto-start fish from bash (from modules/common/shell.nix)
  home.file.".bashrc".text = lib.mkAfter ''
    if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      exec fish
    fi
  '';

  # Homebrew configuration (from modules/darwin/brew.nix)
  home.sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
    "/opt/homebrew/bin"  # Apple Silicon
    "/usr/local/bin"     # Intel Mac
  ];
  
  # Homebrew environment variables
  home.sessionVariables = lib.mkMerge [
    {
      TERM = "xterm-256color";
      PATH = "$HOME/.local/bin:$HOME/scripts:$PATH";
      FLOCASTS_NPM_TOKEN = 
        let secretFile = toString ../secrets/flocasts-npm-token;
        in if builtins.pathExists secretFile 
           then lib.strings.removeSuffix "\n" (builtins.readFile secretFile)
           else "";
    }
    (lib.mkIf pkgs.stdenv.isDarwin {
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1";
      HOMEBREW_CASK_OPTS = "--require-sha";
    })
  ];
  
  # Create homebrew config directory
  home.file.".config/homebrew/.keep".text = lib.mkIf pkgs.stdenv.isDarwin "";

  # macOS system settings (from modules/darwin/system.nix)
  home.activation.macosDefaults = lib.mkIf pkgs.stdenv.isDarwin (lib.hm.dag.entryAfter ["writeBoundary"] ''
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
  '');
}
