{ config, pkgs, ... }:

{
  imports = [
    ../../packages/git/git.nix
  ];
  
  home.packages = with pkgs; [
    gh # GitHub CLI
    git-lfs # Git Large File Storage
    lazygit # Git TUI
    delta # Syntax-highlighting pager for git diffs
  ];
}