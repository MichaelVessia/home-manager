{ config, pkgs, ... }:

{
  imports = [
    ../../packages/neovim/neovim.nix
  ];
  
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}