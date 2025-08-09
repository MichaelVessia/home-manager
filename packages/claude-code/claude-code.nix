{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    curl
    gnutar
    gzip
  ];

  # Install Claude Code CLI using official installer
  # This provides the 'claude' command for CLI and headless environments
  home.activation.installClaudeCLI = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Install Claude Code CLI using official installer with proper PATH
    if ! command -v claude &> /dev/null; then
      export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:''${PATH}"
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL claude.ai/install.sh | ${pkgs.bash}/bin/bash
    fi
  '';
}