{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    curl
    gnutar
    gzip
  ];

  # Install Claude Code CLI and configure settings
  home.activation.installClaudeCLI = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Check if Claude CLI needs installation
    CLAUDE_PATH="$HOME/.local/bin/claude"
    
    if [[ -x "$CLAUDE_PATH" ]]; then
      # Claude CLI is already installed, check if it's working
      if $CLAUDE_PATH --version &>/dev/null; then
        CURRENT_VERSION=$($CLAUDE_PATH --version 2>/dev/null)
        echo "Claude CLI is already installed: $CURRENT_VERSION"
      else
        # Install if not working
        export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:/usr/bin:''${PATH}"
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL claude.ai/install.sh | ${pkgs.bash}/bin/bash
      fi
    else
      # Install Claude Code CLI using official installer
      export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:/usr/bin:''${PATH}"
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL claude.ai/install.sh | ${pkgs.bash}/bin/bash
    fi
    
    # Configure Claude settings
    echo "Configuring Claude CLI settings..."
    $DRY_RUN_CMD mkdir -p $HOME/.claude
    $DRY_RUN_CMD cat > $HOME/.claude/settings.json << 'EOF'
${builtins.toJSON {
      "$schema" = "https://json.schemastore.org/claude-code-settings.json";
      "model" = "opusplan";
    }}
EOF
  '';
}