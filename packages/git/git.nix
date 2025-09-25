{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    gh # GitHub CLI
    git-lfs # Git Large File Storage
    delta # Syntax-highlighting pager for git diffs
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
      core.editor = "nvim";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
        syntax-theme = "Dracula";
        plus-style = "syntax \"#384532\"";
        minus-style = "syntax \"#644242\"";
        hyperlinks = true;
        hyperlinks-file-link-format = "vscode://file/{path}:{line}";
      };
    };
  };
}
