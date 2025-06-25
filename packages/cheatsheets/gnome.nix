{ pkgs }:

pkgs.writeTextFile {
  name = "cheat-gnome";
  text = ''
    # GNOME Custom Keybinds

    ## Application Shortcuts (Pinned Apps)
    Alt+1-9       Switch to pinned application 1-9

    ## Workspace Navigation
    Super+1-6     Switch to workspace 1-6
    
    ## Window Management
    Super+Shift+1-6   Move window to workspace 1-6
  '';
  destination = "/share/cheat/gnome";
}