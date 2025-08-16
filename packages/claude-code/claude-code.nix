{ config, lib, pkgs, ... }:

{
  # Install Node.js to enable npm
  home.packages = with pkgs; [
    nodejs_20
  ];

  # Add npm global bin to PATH for user-installed packages
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  # Set npm prefix to user directory
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # Install Claude Code CLI using npm and configure settings
  home.activation.installClaudeCLI = lib.hm.dag.entryAfter ["writeBoundary"] ''
    PATH="${pkgs.nodejs_20}/bin:$PATH"
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"

    if ! command -v claude >/dev/null 2>&1; then
      echo "Installing Claude Code..."
      npm install -g @anthropic-ai/claude-code
    else
      echo "Claude Code is already installed at $(which claude)"
    fi
    
    # Create/update Claude settings with statusline configuration
    # This runs after the installer to override any default settings
    echo "Configuring Claude statusline..."
    $DRY_RUN_CMD mkdir -p $HOME/.claude
    $DRY_RUN_CMD mkdir -p $HOME/.claude/commands
    # Copy command files from static sources
    echo "Creating Claude command files..."
    $DRY_RUN_CMD cp ${./commands/diff-bugs.md} $HOME/.claude/commands/diff-bugs.md
    $DRY_RUN_CMD cp ${./commands/branch-bugs.md} $HOME/.claude/commands/branch-bugs.md
    $DRY_RUN_CMD cp ${./commands/commit-push-pr.md} $HOME/.claude/commands/commit-push-pr.md
    $DRY_RUN_CMD cp ${./commands/commit-all.md} $HOME/.claude/commands/commit-all.md
    $DRY_RUN_CMD cp ${./commands/commit-chunks.md} $HOME/.claude/commands/commit-chunks.md
    $DRY_RUN_CMD cp ${./commands/commit-and-push.md} $HOME/.claude/commands/commit-and-push.md
    $DRY_RUN_CMD cp ${./commands/resolve-conflicts.md} $HOME/.claude/commands/resolve-conflicts.md
    
    # Install the statusline script with proper permissions
    $DRY_RUN_CMD install -m 755 ${toString ./claude-statusline.sh} $HOME/.claude/claude-statusline
    
    # Copy static settings.json file
    $DRY_RUN_CMD cp ${./settings.json} $HOME/.claude/settings.json
  '';
  # Note: Both the statusline script and settings.json are created in the
  # activation script above to ensure they run AFTER the Claude CLI installer

  # Create ~/.claude/CLAUDE.md with development guidelines from static file
  home.file.".claude/CLAUDE.md".source = ./claude-guidelines.md;

}
