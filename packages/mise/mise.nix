{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mise
  ];
  
  # Add mise to shell initialization
  programs.fish.interactiveShellInit = ''
    mise activate fish | source
  '';
  
  programs.bash.initExtra = ''
    eval "$(mise activate bash)"
  '';
}