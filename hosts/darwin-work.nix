{ lib, config, pkgs, ... }:

let
  # Use actual system username on macOS, configured username on Linux
  username = if pkgs.stdenv.isDarwin then "michael.vessia" else "michaelvessia";
  platform = import ../lib/platform.nix { inherit lib pkgs; };
in
{
  imports = [
    ../modules/common
    ../modules/darwin
    ../packages/aws/aws.nix
    ../packages/claude-code/claude-code.nix
    ../packages/cursor/cursor.nix
    ../packages/fonts/fonts.nix
    ../packages/home-manager/home-manager.nix
    ../packages/jira/jira.nix
    ../packages/karabiner/karabiner.nix
    ../packages/yazi/yazi.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  home = {
    inherit username;
    homeDirectory = platform.homeDirectory username;
    stateVersion = "25.05"; # Don't change this
    
    sessionVariables = {
      TERM = "xterm-256color";
      PATH = "$HOME/.local/bin:$HOME/scripts:$PATH";
      FLOCASTS_NPM_TOKEN = 
        let secretFile = toString ../secrets/flocasts-npm-token;
        in if builtins.pathExists secretFile 
           then lib.strings.removeSuffix "\n" (builtins.readFile secretFile)
           else "";
    };
  };
  
  # Enable font configuration
  fonts.fontconfig.enable = true;
  
  # Chezmoi activation
  home.activation.chezmoi = lib.hm.dag.entryAfter ["installPackages" "generateSshKey"] ''
    PATH="${pkgs.chezmoi}/bin:${pkgs.git}/bin:${pkgs.git-lfs}/bin:${pkgs.openssh}/bin:''${PATH}"

    $DRY_RUN_CMD chezmoi init git@github.com:MichaelVessia/dots.git
    $DRY_RUN_CMD chezmoi update -a
    $DRY_RUN_CMD chezmoi git status
  '';

  # Generate SSH key if it doesn't exist
  home.activation.generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      $DRY_RUN_CMD mkdir -p $HOME/.ssh
      $DRY_RUN_CMD chmod 700 $HOME/.ssh
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "michael.vessia@flosports.tv" -f $HOME/.ssh/id_ed25519 -N ""
      $DRY_RUN_CMD echo "SSH key generated! Add this public key to GitHub:"
      $DRY_RUN_CMD cat $HOME/.ssh/id_ed25519.pub
    fi
    
    # Ensure proper SSH permissions
    if [ -d "$HOME/.ssh" ]; then
      $DRY_RUN_CMD chmod 700 $HOME/.ssh
      $DRY_RUN_CMD chmod 600 $HOME/.ssh/id_ed25519 2>/dev/null || true
      $DRY_RUN_CMD chmod 644 $HOME/.ssh/id_ed25519.pub 2>/dev/null || true
      $DRY_RUN_CMD chmod 600 $HOME/.ssh/config 2>/dev/null || true
    fi
  '';

  # Disable problematic cleanup that uses GNU readlink -e (not available on macOS)
  home.activation.linkGeneration = lib.mkForce "";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}
