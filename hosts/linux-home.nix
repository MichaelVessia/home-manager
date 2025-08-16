{ lib,  pkgs, ... }:

let
  # Share username across various bits of the config
  username = "michaelvessia";
  platform = import ../lib/platform.nix { inherit lib pkgs; };
in
{
  imports = [
    ../packages/linux.nix
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
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "michael@vessia.net" -f $HOME/.ssh/id_ed25519 -N ""
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

  # Make scripts executable

  home.file."scripts/generate-apparmor-profiles.sh" = {
    source = ../scripts/generate-apparmor-profiles.sh;
    executable = true;
  };

  home.file."scripts/open-service.sh" = {
    source = ../scripts/open-service.sh;
    executable = true;
  };

  home.file."scripts/install-docker.sh" = {
    source = ../scripts/install-docker.sh;
    executable = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

}
