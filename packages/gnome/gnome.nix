{ ... }:

{
  dconf.settings = {

   # Text scaling
    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.5;  # 150% text size
    };

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
    
    "org/gnome/shell/keybindings" = {
      switch-to-application-1=[];
      switch-to-application-2=[];
      switch-to-application-3=[];
      switch-to-application-4=[];
      toggle-message-tray=[];
      toggle-overview=["<Ctrl>Up"];
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
      # Disable some conflicting binds
      switch-input-source = [""];
      switch-input-source-backward = [ ];
    };
    
    # Disable Ubuntu Dock number key shortcuts
    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false;
    };

    # Custom keyboard shortcuts
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "UltraWhisper";
      command = "/home/michaelvessia/.config/ultrawhisper/trigger.sh";
      binding = "<Primary>grave";
    };
    
    "org/gnome/shell" = {
      enabled-extensions = [
        "space-bar@luchrioh"
        "switcher@landau.fi"
        "just-perfection-desktop@just-perfection"
      ];

      # Set favorite (pinned) applications in the dash
      favorite-apps = [
        "com.mitchellh.ghostty.desktop"
        "brave-browser.desktop"
        "obsidian.desktop"
        "signal.desktop"
      ];
    };

    "org/gnome/desktop/interface"={
      show-battery-percentage=true;
      enable-hot-corners=false;
      enable-animations=false;
      color-scheme="prefer-dark";
      gtk-theme="Adwaita-dark";
    };
  };
}
