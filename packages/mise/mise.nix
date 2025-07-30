{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mise
    gnupg  # Required for yarn plugin
    libyaml  # Required for Ruby psych extension
  ];
  
  # Add mise to shell initialization
  programs.fish.interactiveShellInit = ''
    if command -q mise
      mise activate fish | source
    end
  '';
  
  programs.bash.initExtra = ''
    eval "$(mise activate bash)"
  '';
  
  # Configure mise settings
  home.file.".config/mise/config.toml".text = ''
    [tools]
    node = "lts"
    ruby = "3.3.6"
    
    [settings]
    idiomatic_version_file_enable_tools = ["node", "yarn", "ruby"]
  '';
  
  # Install yarn plugin on activation
  home.activation.installMiseYarnPlugin = ''
    $VERBOSE_ECHO "Installing mise yarn plugin..."
    $DRY_RUN_CMD ${pkgs.mise}/bin/mise plugin install yarn || true
  '';
}