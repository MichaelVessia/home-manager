# Platform-specific targets
.PHONY: linux
linux:
	home-manager switch --flake .#michaelvessia@linux

# Full darwin update (system + home manager)
.PHONY: darwin
darwin: darwin-system darwin-home

# System-level darwin configuration (requires sudo)
.PHONY: darwin-system
darwin-system:
	@if command -v darwin-rebuild >/dev/null 2>&1; then \
		echo "Activating nix-darwin system configuration..."; \
		sudo darwin-rebuild switch --flake .#work-mac; \
	else \
		echo "Installing nix-darwin first..."; \
		sudo nix run nix-darwin -- switch --flake .#work-mac; \
	fi

# Home Manager configuration for darwin (no sudo required)
.PHONY: darwin-home
darwin-home:
	@echo "Activating Home Manager configuration..."
	home-manager switch --flake .#michaelvessia@darwin


.PHONY: force-update-linux
force-update-linux:
	home-manager switch --flake .#michaelvessia@linux -b backup-$(shell date +%Y%m%d-%H%M%S)
	@echo "Checking AppArmor profiles..."
	@~/scripts/generate-apparmor-profiles.sh || echo "Run 'make apparmor' to update AppArmor profiles"

.PHONY: force-update-darwin
force-update-darwin:
	@if command -v darwin-rebuild >/dev/null 2>&1; then \
		echo "Force updating nix-darwin system configuration..."; \
		sudo darwin-rebuild switch --flake .#work-mac; \
	else \
		echo "Installing nix-darwin first..."; \
		sudo nix run nix-darwin -- switch --flake .#work-mac; \
	fi
	@echo "Force updating Home Manager configuration..."
	home-manager switch --flake .#michaelvessia@darwin -b backup-$(shell date +%Y%m%d-%H%M%S)

# Update AppArmor profiles for Nix packages
.PHONY: apparmor
apparmor:
	@echo "Updating AppArmor profiles (requires sudo)..."
	@sudo ~/scripts/generate-apparmor-profiles.sh

# Nix will only clean up after itself when told to, because it purposefully keeps older generations for rollbacks.
.PHONY: clean
clean:
	nix-collect-garbage -d
