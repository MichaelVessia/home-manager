{ config, pkgs, lib, ... }:

let
  # Platform-specific shell command
  shellCommand = if pkgs.stdenv.isDarwin then
    ''/bin/bash -c "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && exec /Users/michael.vessia/.nix-profile/bin/fish"''
  else
    ''fish'';
in
{
  # Only install the package on Linux since it's broken on Darwin
  # macOS users should install via Homebrew (cask "ghostty")
  home.packages = with pkgs; lib.optionals pkgs.stdenv.isLinux [
    # Install Ghostty wrapped with nixGL for proper OpenGL support (Linux only)
    (config.lib.nixGL.wrap ghostty)
  ];

  # Configuration works on all platforms  
  xdg.configFile = {
    "ghostty/config".text = 
      let configContent = builtins.readFile ./config;
      in builtins.replaceStrings 
        ["SHELL_COMMAND_PLACEHOLDER"] 
        [shellCommand] 
        configContent;
  };
}
