{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  # Install Zsh configuration files using activation script
  home.activation.customZshConfig = lib.hm.dag.entryAfter ["installPackages"] ''
    echo "Installing custom Zsh configuration files..."
    $DRY_RUN_CMD mkdir -p $HOME/.config/zsh
    $DRY_RUN_CMD cp -f ${./zshrc} $HOME/.zshrc
    $DRY_RUN_CMD cp -f ${./functions.zsh} $HOME/.config/zsh/functions.zsh
    $DRY_RUN_CMD chmod 644 $HOME/.zshrc $HOME/.config/zsh/functions.zsh
    echo "Zsh configuration files installed successfully."
  '';

  # Configure plugins with Zsh integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];

    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || echo {}'"
    ];

    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=2 --color=always {} 2>/dev/null || echo {}'"
    ];

    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"  # This makes 'cd' command use zoxide
    ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
      style = "compact";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}