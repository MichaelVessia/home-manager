{ config, pkgs, ... }:

{
  imports = [
    ../../packages/volta/volta.nix
    ../../packages/bun/bun.nix
    ../../packages/cursor/cursor.nix
  ];
  
  home.packages = with pkgs; [
    gcc # C compiler
    gnumake # Build automation tool
    ast-grep # structured grep for code
    curl # data transfer tool
    wget # web file downloader
    jq # JSON processor
    unzip # archive extractor
  ];
}