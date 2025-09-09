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
}
