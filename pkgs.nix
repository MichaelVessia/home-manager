{ pkgs, config, nixgl }:

with pkgs; [
  # Utils
  git
  git-lfs
  # I tried to install brave via pkgs.brave and some other methods
  # I kept getting issues around sandboxing so i just used their installer
  
  # Install Ghostty wrapped with nixGL for proper OpenGL support
  (config.lib.nixGL.wrap ghostty)
  
  # Optional: Install some nice fonts for the terminal
  jetbrains-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  
  # Makes the gnome workspaces nicer
  gnomeExtensions.space-bar
  
  # Dotfiles management for things I don't want to manage via nix
  chezmoi

  # Development tools
  gcc
  gnumake
  tree-sitter
  volta
  fzf
  ripgrep
  fd
]
