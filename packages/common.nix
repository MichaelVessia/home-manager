{ config, pkgs, lib, ... }:

{
  imports = [
    # Shell and terminal
    ./fish/fish.nix
    ./nushell/nushell.nix
    ./starship/starship.nix
    ./ghostty/ghostty.nix
    
    # Editor
    ./neovim/neovim.nix
    
    # Version control
    ./git/git.nix
    ./lazygit/lazygit.nix
    
    # Development tools
    ./mise/mise.nix
    ./bun/bun.nix
    ./cursor/cursor.nix
    
    # System utilities
    ./yazi/yazi.nix
    
    # Applications
    ./obsidian/obsidian.nix
    ./spotify/spotify.nix
    ./brave/brave.nix
    
    # System management
    ./fonts/fonts.nix
    ./chezmoi/chezmoi.nix
    ./cheatsheets/default.nix
    
    # Development environment
    ./claude-code/claude-code.nix
  ];

  # Common packages that don't need their own files
  home.packages = with pkgs; [
    # Development tools
    gcc # C compiler
    gnumake # Build automation tool
    ast-grep # structured grep for code
    curl # data transfer tool
    wget # web file downloader
    jq # JSON processor
    unzip # archive extractor
    zip # zip compression
    p7zip # 7-Zip file archiver
    direnv # automatic environment management
    
    # System utilities
    htop # interactive process viewer (better than top)
    glances # Lists all processes + cpu/memory
    lsof # list open files and network connections
    bat # syntax-highlighted file previews
    eza # modern ls replacement
    fd # fast file finder (better than find)
    fzf # fuzzy finder
    ripgrep # fast text search (better than grep)
    tree # directory tree viewer
    watch # run commands repeatedly
    less # pager program
    nmap # network discovery and security auditing
    traceroute # trace network route to a host
    whois # domain lookup tool
    rsync # fast file synchronization tool
    openssh # SSH client/server
    gnupg # OpenPGP implementation
  ];
}