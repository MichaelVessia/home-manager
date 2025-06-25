{ pkgs }:

pkgs.writeTextFile {
  name = "cheat-ghostty";
  text = ''
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
  destination = "/share/cheat/ghostty";
}