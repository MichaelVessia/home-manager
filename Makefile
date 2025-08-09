# Platform-specific targets
.PHONY: linux
linux:
	home-manager switch --flake .#michaelvessia@linux

.PHONY: darwin
darwin:
	home-manager switch --flake .#michaelvessia@darwin


.PHONY: force-update-linux
force-update-linux:
	home-manager switch --flake .#michaelvessia@linux -b backup-$(shell date +%Y%m%d-%H%M%S)
	@echo "Checking AppArmor profiles..."
	@~/scripts/generate-apparmor-profiles.sh || echo "Run 'make apparmor' to update AppArmor profiles"

.PHONY: force-update-darwin
force-update-darwin:
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
