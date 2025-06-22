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

  # Basic config for installed programs
  # Probably want to manage actual dotfiles in another way
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Git config using Home Manager modules
    git = {
      enable = true;
      userName = username;
      userEmail = "michael@vessia.net";
      aliases = {
        st = "status";
      };
    };
  };

  xdg = {
    configFile = {
      # Configure Ghostty
      "ghostty/config".text = ''
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
    };
  };
dconf.settings = {
    # Workspace settings
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };
    
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 6;
    };
    
    # Alt + number for pinned applications
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = ["<Alt>1"];
      switch-to-application-2 = ["<Alt>2"];
      switch-to-application-3 = ["<Alt>3"];
      switch-to-application-4 = ["<Alt>4"];
      switch-to-application-5 = ["<Alt>5"];
      switch-to-application-6 = ["<Alt>6"];
      switch-to-application-7 = ["<Alt>7"];
      switch-to-application-8 = ["<Alt>8"];
      switch-to-application-9 = ["<Alt>9"];
    };
    
    # Super + number for workspace switching
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];

      # Add move-to-workspace keys
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
    };

    # Disable Ubuntu Dock number key shortcuts
    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false;
    };
  };
}
