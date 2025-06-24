{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # neovim-specific packages
    tree-sitter # syntax highlighting for neovim
    imagemagickBig # image support in neovim
    tectonic # PDF support for neovim
    mermaid-cli # mermaid diagram support
    luarocks # Lua package manager for neovim
    lua # Lua language for neovim config
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
