{ ... }:

{
  dconf.settings = {

   # Scrolling settings
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;  # Set to true for Mac-like scrolling
      tap-to-click = true;     # Optional: enable tap to click
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;  # Set to true for Mac-like scrolling
    };

    # Workspace settings
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      center-new-windows = true;
    };
    
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 6;
    };
    
    # Alt + number for pinned applications
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = ["<Alt>1"];
      switch-to-application-2 = ["<Alt>2"];
      switch-to-application-3 = ["<Alt>3"];
      switch-to-application-4 = ["<Alt>4"];
      switch-to-application-5 = ["<Alt>5"];
      switch-to-application-6 = ["<Alt>6"];
      switch-to-application-7 = ["<Alt>7"];
      switch-to-application-8 = ["<Alt>8"];
      switch-to-application-9 = ["<Alt>9"];
    };
    
    # Super + number for workspace switching
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      # Add move-to-workspace keys
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
    };
    
    # Disable Ubuntu Dock number key shortcuts
    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false;
    };
    
    "org/gnome/shell" = {
      enabled-extensions = [
        "space-bar@luchrioh"
      ];
      # Set favorite (pinned) applications in the dash
      favorite-apps = [
        "ghostty.desktop"
        "brave-browser.desktop"
        "obsidian.desktop"
        "signal-desktop.desktop"
      ];
    };
  };
}
