{ lib, pkgs, ... }:

{
  # Helper functions for platform-specific configuration
  
  # Check if we're on macOS
  isDarwin = pkgs.stdenv.isDarwin;
  
  # Check if we're on Linux
  isLinux = pkgs.stdenv.isLinux;
  
  # Get the appropriate home directory path
  homeDirectory = username:
    if pkgs.stdenv.isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";
  
  # Platform-specific package installation
  # Some packages might need different installation methods on different platforms
  mkPlatformPackage = { linux ? null, darwin ? null }:
    if pkgs.stdenv.isLinux && linux != null then linux
    else if pkgs.stdenv.isDarwin && darwin != null then darwin
    else null;
  
  # Conditional module imports based on platform
  platformModules = { common ? [], linux ? [], darwin ? [] }:
    common ++ (
      if pkgs.stdenv.isLinux then linux
      else if pkgs.stdenv.isDarwin then darwin
      else []
    );
}