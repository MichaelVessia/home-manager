{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # System monitoring
    htop # interactive process viewer (better than top)
    glances # Lists all processes + cpu/memory
    lsof # list open files and network connections
    
    # File utilities
    bat # syntax-highlighted file previews
    eza # modern ls replacement
    fd # fast file finder (better than find)
    fzf # fuzzy finder
    ripgrep # fast text search tool (better than grep)
    tree # directory tree viewer
    ncdu # disk usage analyzer with ncurses interface
    atuin # Replacement for shell history
    
    # Development utilities  
    gh # GitHub CLI
    git-lfs # Git Large File Storage
    lazygit # Git TUI
    gcc # C compiler
    gnumake # Build automation tool
    ast-grep # structured grep for code
    
    # System utilities
    xsel # clipboard manager
    chezmoi # dotfiles manager
    cheat # cheatsheet for shortcuts
    
    # Common tools
    curl # data transfer tool
    wget # web file downloader
    jq # JSON processor
    unzip # archive extractor
    glow # render markdown in terminal
  ];
}
