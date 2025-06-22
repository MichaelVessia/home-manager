{ config, pkgs, ... }:

let
  # Import nixGL for OpenGL support on non-NixOS systems
  nixgl = import (fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") {
    inherit pkgs;
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "michaelvessia";
  home.homeDirectory = "/home/michaelvessia";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Enable nixGL integration
  nixGL.packages = nixgl;
  
  # Configure nixGL wrapper based on your GPU
  # For Intel/AMD Mesa drivers:
  nixGL.defaultWrapper = "mesa";
  # For Nvidia proprietary drivers, uncomment the line below and comment out mesa:
  # nixGL.defaultWrapper = "nvidia";
  
  # Install wrapper scripts
  nixGL.installScripts = [ "mesa" ];  # Change to [ "nvidia" ] if using Nvidia

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    # # It is sometimes useful to fine-tune packages, for example, by applying

    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.vim
    pkgs.git
    # I tried to install brave via pkgs.brave and some other methods
    # I kept getting issues around sandboxing so i just used their installer
    
    # Install Ghostty wrapped with nixGL for proper OpenGL support
    (config.lib.nixGL.wrap pkgs.ghostty)
    
    # Optional: Install some nice fonts for the terminal
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/michaelvessia/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    
    # Uncomment these if you still have GL issues:
    # LIBGL_ALWAYS_SOFTWARE = "1";  # Force software rendering
    # GALLIUM_DRIVER = "llvmpipe";   # Use llvmpipe driver
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git config using Home Manager modules
  programs.git = {
    enable = true;
    userName = "michaelvessia";
    userEmail = "michael@vessia.net";
    aliases = {
      st = "status";
    };
  };
}
