{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    mise
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    gnupg  # Required for yarn plugin (macOS only)
    libyaml  # Required for Ruby psych extension (macOS only)
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
    ${lib.optionalString pkgs.stdenv.isDarwin "ruby = \"3.3.6\""}
    
    [settings]
    idiomatic_version_file_enable_tools = [${lib.concatStringsSep ", " (
      ["\"node\""] ++ lib.optionals pkgs.stdenv.isDarwin ["\"yarn\"" "\"ruby\""]
    )}]
  '';
  
  # Install yarn plugin on activation (macOS only)
  home.activation.installMiseYarnPlugin = lib.mkIf pkgs.stdenv.isDarwin ''
    $VERBOSE_ECHO "Installing mise yarn plugin..."
    $DRY_RUN_CMD ${pkgs.mise}/bin/mise plugin install yarn || true
  '';
}