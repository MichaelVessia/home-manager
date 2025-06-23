{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
  ];

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
