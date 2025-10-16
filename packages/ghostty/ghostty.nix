{ config, pkgs, lib, ... }:
{
  # Only install the package on Linux since it's broken on Darwin
  # macOS users should install via Homebrew (cask "ghostty")
  home.packages = with pkgs; lib.optionals pkgs.stdenv.isLinux [
    # Install Ghostty wrapped with nixGL for proper OpenGL support (Linux only)
    (config.lib.nixGL.wrap ghostty)
  ];

  home.activation.ghostty = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.config/ghostty/themes
    $DRY_RUN_CMD cp -f ${./config} $HOME/.config/ghostty/config
    $DRY_RUN_CMD cp -f ${./catppuccin-frappe} $HOME/.config/ghostty/themes/catppuccin-frappe
  '';
}
