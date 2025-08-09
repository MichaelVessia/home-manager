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
    # Check if Claude CLI needs installation or update
    EXPECTED_VERSION="1.0.72"  # Update this when new versions are released
    CLAUDE_PATH="$HOME/.local/bin/claude"
    
    if [[ -x "$CLAUDE_PATH" ]]; then
      CURRENT_VERSION=$($CLAUDE_PATH --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
      if [[ "$CURRENT_VERSION" == "$EXPECTED_VERSION" ]]; then
        echo "Claude CLI $CURRENT_VERSION is already installed and current"
        exit 0
      fi
    fi
    
    # Install or update Claude Code CLI using official installer
    export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:/usr/bin:''${PATH}"
    $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL claude.ai/install.sh | ${pkgs.bash}/bin/bash
  '';
}