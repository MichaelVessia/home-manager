{ pkgs, username, ... }:

{
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
  
  # Basic nvim setup, but we'll manage dots with chezmoi
  neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
