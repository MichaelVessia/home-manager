{ lib, config, pkgs, ... }:

let
  # Share username across various bits of the config
  username = "michaelvessia";
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
    
    # Linux-specific packages (from modules/linux)
    ../packages/apparmor/apparmor-profiles.nix
    ../packages/nixgl/nixgl.nix
    ../packages/signal-desktop/signal-desktop.nix
    ../packages/bitwarden/bitwarden.nix
    ../packages/tailscale/tailscale.nix
    ../packages/syncthing/syncthing.nix
    ../packages/media/media.nix
    ../packages/gnome/gnome.nix
    ../packages/gnome-extensions/gnome-extensions.nix
    ../packages/gnome-network-displays/gnome-network-displays.nix
    
    # Originally imported at host level
    ../packages/brave/brave.nix
    ../packages/claude-code/claude-code.nix
    ../packages/fonts/fonts.nix
    ../packages/home-manager/home-manager.nix
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
    
    sessionVariables = {
      TERM = "xterm-256color";
      PATH = "$HOME/.local/bin:$HOME/scripts:$PATH";
    };
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
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "michael@vessia.net" -f $HOME/.ssh/id_ed25519 -N ""
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

  # Make scripts executable

  home.file."scripts/generate-apparmor-profiles.sh" = {
    source = ../scripts/generate-apparmor-profiles.sh;
    executable = true;
  };

  home.file."scripts/open-service.sh" = {
    source = ../scripts/open-service.sh;
    executable = true;
  };

  home.file."scripts/install-docker.sh" = {
    source = ../scripts/install-docker.sh;
    executable = true;
  };

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
    
    # From modules/linux/packages.nix - Linux-specific packages
    xsel # clipboard manager (Linux-specific)
    kooha # screen recorder (Linux-specific)
    pinta # image editor
    ffmpeg # video/audio converter
  ];

  # Auto-start fish from bash (from modules/common/shell.nix)
  home.file.".bashrc".text = lib.mkAfter ''
    if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      exec fish
    fi
  '';
}
