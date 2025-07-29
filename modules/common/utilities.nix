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
    
    # Common tools
    glow # render markdown in terminal
    chezmoi # dotfiles manager
    cheat # cheatsheet for shortcuts
  ];
  
  imports = [
    ../../packages/cheatsheets/default.nix
  ];
}