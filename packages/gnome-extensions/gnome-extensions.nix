{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-extension-manager
    gnome-shell-extensions
    gnome-extensions-cli

    gnomeExtensions.space-bar
    gnomeExtensions.switcher
    gnomeExtensions.just-perfection
  ];
}
