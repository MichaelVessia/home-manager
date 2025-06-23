{ pkgs, config, nixgl }:

with pkgs; [
  # Utils
  git
  git-lfs
  eza
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
  
  chezmoi # Dotfiles management for things I don't want to manage via nix

  # Development tools
  gcc # c compiler for nvim
  gnumake # for use with gcc
  tree-sitter # for nvim
  volta # manage node versions
  fzf # fuzzy find
  ripgrep # search text
  fd # search files
  imagemagickBig # support images in nvim
  tectonic # pdf support
  mermaid-cli # mermaid diagrams
  lazygit # git tui
  luarocks # lua pkg manager
  ast-grep # Structured grep
  lua # Lua language

  # media
  feh
  vlc
  yt-dlp

]
