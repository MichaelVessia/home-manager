{ config, pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
      refresher = {
        refreshInterval = 10;
        fetchInterval = 60;
      };
    };
  };
}