{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
  ];

  programs.git = {
    enable = true;
    userName = "michaelvessia";
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
