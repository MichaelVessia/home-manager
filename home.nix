{ lib, config, pkgs, ... }:

let
  # Share username across various bits of the config
  username = "michaelvessia";
  platform = import ./lib/platform.nix { inherit lib pkgs; };
in
{
  # DEPRECATED: This file is deprecated in favor of the new modular structure.
  # Use hosts/linux-home.nix or hosts/darwin-work.nix instead.
  #
  # To migrate:
  # - For Linux: home-manager switch --flake .#michaelvessia@linux
  # - For macOS: home-manager switch --flake .#michaelvessia@darwin
  #
  # The old imports below are kept for reference but should not be used.

  imports = [
    # Old structure - use hosts/ files instead
    ./packages/nixgl/nixgl.nix
    ./packages/gnome/gnome.nix
    ./packages/signal-desktop/signal-desktop.nix
    ./packages/ghostty/ghostty.nix
    ./packages/neovim/neovim.nix
    ./packages/fish/fish.nix
    ./packages/starship/starship.nix
    ./packages/git/git.nix
    ./packages/utilities/utilities.nix
    ./packages/fonts/fonts.nix
    ./packages/gnome-extensions/gnome-extensions.nix
    ./packages/volta/volta.nix
    ./packages/media/media.nix
    ./packages/home-manager/home-manager.nix
    ./packages/apparmor/apparmor-profiles.nix
    ./packages/brave/brave.nix
    ./packages/obsidian/obsidian.nix
    ./packages/syncthing/syncthing.nix
    ./packages/cursor/cursor.nix
    ./packages/bitwarden/bitwarden.nix
    ./packages/spotify/spotify.nix
    ./packages/cheatsheets/default.nix
    ./packages/bun/bun.nix
    ./packages/gnome-network-displays/gnome-network-displays.nix
    ./packages/tailscale/tailscale.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05"; # Don't change this
    
    sessionVariables = {
      EDITOR = "nvim";
      TERM = "xterm-256color";
      PATH = "$HOME/scripts:$PATH";
    };
  };
  
  # Enable font configuration
  fonts.fontconfig.enable = true;
  
 
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

  # Auto-start fish from bash
home.file.".bashrc".text = lib.mkAfter ''
  if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
  then
    exec fish
  fi
'';

  # Make scripts executable
  home.file."scripts/setup-node.sh" = {
    source = ./scripts/setup-node.sh;
    executable = true;
  };

  home.file."scripts/generate-apparmor-profiles.sh" = {
    source = ./scripts/generate-apparmor-profiles.sh;
    executable = true;
  };

  home.file."scripts/open-service.sh" = {
    source = ./scripts/open-service.sh;
    executable = true;
  };

  home.file."scripts/install-docker.sh" = {
    source = ./scripts/install-docker.sh;
    executable = true;
  };

nixpkgs = {
		config = {
			allowUnfree = true;
			allowUnfreePredicate = (_: true);
		};
	};
}