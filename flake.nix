{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add nix-darwin for macOS support
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }:
    let
      # Systems we support
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      
      # Helper function to generate outputs for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # Package sets for each system
      pkgsFor = forAllSystems (system: 
        import nixpkgs { 
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };
        }
      );
    in {
      # Home Manager configurations
      homeConfigurations = {
        # Linux home configuration
        "michaelvessia@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./hosts/linux-home.nix ];
        };
        
        # macOS work configuration (adjust architecture as needed)
        "michaelvessia@darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.aarch64-darwin; # Use x86_64-darwin if on Intel Mac
          modules = [ ./hosts/darwin-work.nix ];
        };
      };
      
      # Darwin system configurations for system-level macOS settings
      darwinConfigurations = {
        "work-mac" = darwin.lib.darwinSystem {
          system = "aarch64-darwin"; # Use x86_64-darwin if on Intel Mac
          modules = [
            ./hosts/darwin-system.nix
            # Enable home-manager integration
            {
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
      };
    };
}