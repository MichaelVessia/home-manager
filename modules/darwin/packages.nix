{ config, pkgs, lib, ... }:

{
  # macOS-specific packages installed via Nix
  home.packages = with pkgs; lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific CLI tools
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
    
    # Add any macOS-specific packages here
  ];
}