{ config, pkgs, lib, ... }:

{
  # Homebrew management (optional - requires manual Homebrew installation)
  # This is useful for GUI apps that aren't available in nixpkgs for macOS
  
  home.activation.brewBundle = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ "$(uname)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
      # Create a Brewfile
      cat > "$HOME/.config/homebrew/Brewfile" <<EOF
# GUI Applications (casks)
# Add any macOS-specific GUI apps here that aren't in nixpkgs
# Example:
# cask "rectangle"  # Window management
# cask "alfred"     # Spotlight replacement

# CLI tools that work better from Homebrew
# brew "mas"  # Mac App Store CLI

# Mac App Store apps (requires mas)
# mas "Amphetamine", id: 937984704
EOF
      
      # Install/update from Brewfile
      $DRY_RUN_CMD brew bundle --file="$HOME/.config/homebrew/Brewfile" --no-lock || true
    fi
  '';
  
  # Ensure the Brewfile directory exists
  home.file.".config/homebrew/.keep".text = "";
}