{ config, pkgs, lib, ... }:

{
  imports = [
    # Core applications
    ./obsidian/obsidian.nix
    ./spotify/spotify.nix
    
    # Development tools
    ./bun/bun.nix
    ./neovim/neovim.nix
    ./git/git.nix
    ./direnv/direnv.nix
    
    # Shell & terminal
    ./zsh/zsh.nix
    ./nushell/nushell.nix
    ./starship/starship.nix
    ./ghostty/ghostty.nix
    
    # Utilities
    ./cheatsheets/default.nix
    ./chezmoi/chezmoi.nix
    ./lazygit/lazygit.nix
    ./yazi/yazi.nix
  ];
  
  home.packages = with pkgs; [
    # System monitoring
    btop
    htop
    glances
    lsof
    
    # File utilities
    bat
    eza
    fd
    fzf
    ripgrep
    tree
    ncdu
    atuin
    zoxide
    
    # Development utilities  
    gcc
    gnumake
    ast-grep
    devbox
    nix-direnv
    nodejs_22
    git-town

    
    # Common tools
    curl
    wget
    jq
    unzip
    glow
    typst
    ffmpeg
    cheat
  ];
  
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
