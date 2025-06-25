{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
  ];

  # Set Brave as the default browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["brave-browser.desktop"];
      "x-scheme-handler/http" = ["brave-browser.desktop"];
      "x-scheme-handler/https" = ["brave-browser.desktop"];
      "x-scheme-handler/ftp" = ["brave-browser.desktop"];
      "x-scheme-handler/chrome" = ["brave-browser.desktop"];
      "application/x-extension-htm" = ["brave-browser.desktop"];
      "application/x-extension-html" = ["brave-browser.desktop"];
      "application/x-extension-shtml" = ["brave-browser.desktop"];
      "application/xhtml+xml" = ["brave-browser.desktop"];
      "application/x-extension-xhtml" = ["brave-browser.desktop"];
      "application/x-extension-xht" = ["brave-browser.desktop"];
      
      # Video mime types that might open in browser
      "video/webm" = ["brave-browser.desktop"];
      "video/mp4" = ["brave-browser.desktop"];
      "video/x-matroska" = ["brave-browser.desktop"];
    };
  };

  # Also set environment variables for terminal applications
  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
    BROWSER = "${pkgs.brave}/bin/brave";
  };
}