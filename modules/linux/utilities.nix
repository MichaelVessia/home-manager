{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Linux-specific system utilities
    xsel # clipboard manager
    kooha # screen recorder
    pinta # image editor
  ];
}