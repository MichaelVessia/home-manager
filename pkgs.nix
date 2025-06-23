{ pkgs, config, nixgl }:

with pkgs; [
  # Utils
  git
  git-lfs
  eza
  # I tried to install brave via pkgs.brave and some other methods
  # I kept getting issues around sandboxing so i just used their installer
  
  # Optional: Install some nice fonts for the terminal
  jetbrains-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  
  # Makes the gnome workspaces nicer
  gnomeExtensions.space-bar
  
  chezmoi # Dotfiles management for things I don't want to manage via nix

  # Development tools
  volta # manage node versions

  # media
  feh
  vlc
  yt-dlp

]
