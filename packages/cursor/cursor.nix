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
    # Check if Cursor Agent CLI needs installation or update
    CURSOR_AGENT_PATH="$HOME/.local/bin/cursor-agent"
    
    if [[ -x "$CURSOR_AGENT_PATH" ]]; then
      # Cursor Agent is already installed, check if it's working
      if $CURSOR_AGENT_PATH --version &>/dev/null; then
        CURRENT_VERSION=$($CURSOR_AGENT_PATH --version 2>/dev/null | head -1)
        echo "Cursor Agent is already installed: $CURRENT_VERSION"
        exit 0
      fi
    fi
    
    # Install or update Cursor Agent CLI using official installer
    export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:''${PATH}"
    $DRY_RUN_CMD ${pkgs.curl}/bin/curl https://cursor.com/install -fsSL | ${pkgs.bash}/bin/bash
  '';
}
