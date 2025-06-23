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
      co = "checkout";
      br = "branch";
      ci = "commit";
    };
    extraConfig = {
      url."git@github.com:".insteadOf = "https://github.com/";
      push.autoSetupRemote = true;
    };
};
}
