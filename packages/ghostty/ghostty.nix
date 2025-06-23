{ config, pkgs, ... }:

{

	home.packages = with pkgs; [
    # Install Ghostty wrapped with nixGL for proper OpenGL support
    (config.lib.nixGL.wrap ghostty)
	];

  xdg.configFile = {
    "ghostty/config".text = ''
      # Font configuration
      font-family = JetBrains Mono
      font-size = 12
      
      # Theme (dark or light)
      theme = dark:catppuccin-frappe,light:catppuccin-latte
      
      # Background opacity (0.0 to 1.0, where 1.0 is fully opaque)
      background-opacity = 0.95
      
      # Window padding
      window-padding-x = 10
      window-padding-y = 10
      
      # Cursor style (block, bar, or underline)
      cursor-style = block
      
      # Enable bold fonts
      bold-is-bright = true
      
      # Shell integration
      shell-integration = detect
    '';
  };
}
