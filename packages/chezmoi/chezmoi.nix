{ config, pkgs, lib, ... }:

{
  # Configure chezmoi to use fish shell - works cross-platform
  home.file.".config/chezmoi/chezmoi.toml".text = ''
    [cd]
      command = "${pkgs.fish}/bin/fish"
  '';
}