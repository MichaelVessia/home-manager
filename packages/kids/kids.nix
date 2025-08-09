{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  home.packages = with pkgs; [
    # Fun command-line toys
    sl                # Steam locomotive when you type ls wrong
    cowsay           # ASCII cow with speech bubbles
    fortune          # Random quotes and jokes
    figlet           # ASCII art text
    lolcat           # Rainbow colored text
    cmatrix          # Matrix-style falling text
    asciiquarium     # ASCII aquarium
    pipes            # Animated pipes screensaver
    
    # Sound and speech
    espeak           # Text to speech
    beep             # System beep utility
    
    # Games
    bastet           # Tetris clone
    ninvaders        # Space invaders clone
    moon-buggy       # Moon buggy game
    nsnake           # Snake game
    
    # Educational
    bc               # Calculator
    units            # Unit conversion
  ];
}