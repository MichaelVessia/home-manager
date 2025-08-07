{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    code-cursor
    curl
    gnutar
    gzip
  ];

  # Install Cursor Agent CLI - allows using Cursor Agent from CLI or headless environments
  # This is in addition to the main Cursor editor (code-cursor package above)
  home.activation.installCursorCLI = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Install Cursor CLI using official installer with proper PATH
    if ! command -v cursor-agent &> /dev/null; then
      export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:''${PATH}"
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl https://cursor.com/install -fsSL | ${pkgs.bash}/bin/bash
    fi
  '';
}
