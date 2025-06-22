{ config, pkgs, ... }:

let
  # Import nixGL for OpenGL support on non-NixOS systems
  nixgl = import (fetchTarball {
    url = "https://github.com/nix-community/nixGL/archive/main.tar.gz";
    sha256 = "1crnbv3mdx83xjwl2j63rwwl9qfgi2f1lr53zzjlby5lh50xjz4n";
  }) {
    inherit pkgs;
  };
  # Share username across various bits of the config
  username = "michaelvessia";
in
{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05"; # Don't change this
    packages = with pkgs; [
      vim
      git
      # I tried to install brave via pkgs.brave and some other methods
      # I kept getting issues around sandboxing so i just used their installer
      
      # Install Ghostty wrapped with nixGL for proper OpenGL support
      (config.lib.nixGL.wrap ghostty)
      
      # Optional: Install some nice fonts for the terminal
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
    sessionVariables = {
	    EDITOR = "vim";
    };
  };

  nixGL = {
    # Enable nixGL integration
    packages = nixgl;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # Configure Ghostty
  xdg.configFile."ghostty/config".text = ''
    # Font configuration
    font-family = JetBrains Mono
    font-size = 12
    
    # Theme (dark or light)
    theme = dark:catppuccin-frappe,light:catppuccin-latte

    
    # Background opacity (0.0 to 1.0, where 1.0 is fully opaque)
    background-opacity = 0.95
    
    # Window padding
    window-padding-x = 10
    window-padding-y = 10
    
    # Cursor style (block, bar, or underline)
    cursor-style = block
    
    # Enable bold fonts
    bold-is-bright = true
    
    # Shell integration
    shell-integration = detect
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git config using Home Manager modules
  programs.git = {
    enable = true;
    userName = username;
    userEmail = "michael@vessia.net";
    aliases = {
      st = "status";
    };
  };

}
