{ config, pkgs, lib, ... }:

{
  imports = [
    ../../packages/fish/fish.nix
    ../../packages/starship/starship.nix
  ];
  
  home.packages = with pkgs; [
    atuin # Replacement for shell history
  ];
  
  # Auto-start fish from bash
  home.file.".bashrc".text = lib.mkAfter ''
    if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      exec fish
    fi
  '';
}