{ config, pkgs, ... }:

let
  # Share username across various bits of the config
  username = "michaelvessia";
in
{
  imports = [
    ./nixgl.nix
    ./ghostty.nix
    ./gnome.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05"; # Don't change this
    
    # Import packages from separate file
    packages = import ./pkgs.nix { 
      inherit pkgs config; 
      inherit (config._module.args) nixgl;
    };
    
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
  
  # Enable font configuration
  fonts.fontconfig.enable = true;
  
  # Import programs configuration
  programs = import ./programs.nix { inherit pkgs username; };
}
