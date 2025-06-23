{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # neovim
    # Also add all the things I installed for neovim compat
    # These are not necessarily neovim specific
    # So maybe ill move them
    gcc # c compiler for nvim
    gnumake # for use with gcc
    tree-sitter # for nvim
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
    xsel # clipboard manager
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
