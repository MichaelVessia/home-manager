{ config, pkgs, lib, ... }:

{
  imports = [
    # macOS-specific packages
    ./aws/aws.nix
    ./cursor/cursor.nix
    ./jira/jira.nix
    ./karabiner/karabiner.nix
    
    # System settings and Homebrew integration
    ./darwin-system.nix
  ];
  
  # macOS-specific packages installed via Nix
  home.packages = with pkgs; lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific CLI tools
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
    
    # GNU utilities to replace BSD versions on macOS
    coreutils # Provides greadlink/readlink with GNU options (-e, -m) needed by Home Manager
  ];
}