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
    
    # Language servers (instead of using Mason)
    #nil # Nix language server
    #lua-language-server # Lua language server
    #stylua # Lua formatter
    #shfmt # Shell formatter
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    # Make Rust toolchain available to LazyVim's Nix extra
    extraPackages = with pkgs; [
      cargo
      rustc
      rust-analyzer # LSP server for Rust
    ];
  };
}
