{ pkgs, ... }:

let
  # Import nixGL for OpenGL support on non-NixOS systems
  nixgl = import (fetchTarball {
    url = "https://github.com/nix-community/nixGL/archive/main.tar.gz";
    sha256 = "1crnbv3mdx83xjwl2j63rwwl9qfgi2f1lr53zzjlby5lh50xjz4n";
  }) {
    inherit pkgs;
  };
in
{
  nixGL = {
    # Enable nixGL integration
    packages = nixgl;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };
  
  # Export nixgl for use in other modules
  _module.args.nixgl = nixgl;
}
