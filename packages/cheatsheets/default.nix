{ config, pkgs, lib, ... }:

let
  # Function to create a cheatsheet derivation
  mkCheatsheet = name: content: pkgs.writeTextFile {
    name = "cheat-${name}";
    text = content;
    destination = "/share/cheat/${name}";
  };

  # Ghostty cheatsheet
  ghosttyCheatsheet = mkCheatsheet "ghostty" ''
    # Ghostty Custom Keybinds
    # Leader key: Ctrl+A

    ## Tab Navigation
    Ctrl+A, 1-9   Go to tab 1-9
    Ctrl+A, 0     Go to last tab
    Ctrl+A, p     Previous tab
    Ctrl+A, n     Next tab

    ## Tab Management
    Ctrl+A, c     New tab
    Ctrl+A, x     Close tab
    Ctrl+A, h     Move tab left
    Ctrl+A, l     Move tab right
    Ctrl+A, t     Toggle tab overview
  '';

  # GNOME cheatsheet
  gnomeCheatsheet = mkCheatsheet "gnome" ''
    # GNOME Custom Keybinds

    ## Application Shortcuts (Pinned Apps)
    Alt+1-9       Switch to pinned application 1-9

    ## Workspace Navigation
    Super+1-6     Switch to workspace 1-6
    
    ## Window Management
    Super+Shift+1-6   Move window to workspace 1-6
  '';

  # Combined cheatsheets package
  cheatsheets = pkgs.symlinkJoin {
    name = "custom-cheatsheets";
    paths = [
      ghosttyCheatsheet
      gnomeCheatsheet
    ];
  };

in
{
  # Install cheat and the cheatsheets
  home.packages = with pkgs; [
    cheat
    cheatsheets
  ];

  # Configure cheat to use our custom cheatsheets
  home.sessionVariables = {
    CHEAT_USE_FZF = "true";
  };

  # Configure cheat with additional settings
  xdg.configFile."cheat/conf.yml".text = ''
    # The directories containing cheatsheets
    cheatpaths:
      - name: custom
        path: ${cheatsheets}/share/cheat
        tags: [ custom ]
        readonly: true

    # Colorization settings
    colorize: true

    # Editor settings
    editor: vim
  '';
}