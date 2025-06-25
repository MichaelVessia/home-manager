{ config, pkgs, lib, ... }:

let
  # Import individual cheatsheets
  ghosttyCheatsheet = import ./ghostty.nix { inherit pkgs; };
  gnomeCheatsheet = import ./gnome.nix { inherit pkgs; };

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