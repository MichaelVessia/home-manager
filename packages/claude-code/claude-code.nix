{ config, lib, pkgs, ... }:

{
  # Dependencies needed for Claude CLI installation
  home.packages = with pkgs; [
    curl
    gnutar
    gzip
  ];

   # Add ~/.local/bin to PATH so we can run the claude command
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Install Claude Code CLI using official installer and configure settings
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
    
    # Create/update Claude settings with statusline configuration
    # This runs after the installer to override any default settings
    echo "Configuring Claude statusline..."
    $DRY_RUN_CMD mkdir -p $HOME/.claude
    $DRY_RUN_CMD mkdir -p $HOME/.claude/commands
    # Copy command files from static sources
    echo "Creating Claude command files..."
    $DRY_RUN_CMD cp -f ${./commands/commit-all.md} $HOME/.claude/commands/commit-all.md
    $DRY_RUN_CMD cp -f ${./commands/commit-and-push.md} $HOME/.claude/commands/commit-and-push.md
    $DRY_RUN_CMD cp -f ${./commands/commit-message.md} $HOME/.claude/commands/commit-message.md
    $DRY_RUN_CMD cp -f ${./commands/commit-push-pr.md} $HOME/.claude/commands/commit-push-pr.md
    $DRY_RUN_CMD cp -f ${./commands/create-note.md} $HOME/.claude/commands/create-note.md
    $DRY_RUN_CMD cp -f ${./commands/dump-context.md} $HOME/.claude/commands/dump-context.md
    $DRY_RUN_CMD cp -f ${./commands/implement-jira.md} $HOME/.claude/commands/implement-jira.md
    
    # Install the statusline script with proper permissions
    $DRY_RUN_CMD install -m 755 ${toString ./claude-statusline.sh} $HOME/.claude/claude-statusline
    
    # Copy static settings.json file
    $DRY_RUN_CMD cp -f ${./settings.json} $HOME/.claude/settings.json
    
    # Copy static CLAUDE.md file
    $DRY_RUN_CMD cp -f ${./claude-guidelines.md} $HOME/.claude/CLAUDE.md
  '';
  # Note: The statusline script, settings.json, and CLAUDE.md are all created in the
  # activation script above to ensure they run AFTER the Claude CLI installer

}
