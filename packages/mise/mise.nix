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
  
  # Configure mise settings
  home.file.".config/mise/config.toml".text = ''
    [settings]
    idiomatic_version_file_enable_tools = ["node"]
  '';
}