.PHONY: update
update:
	home-manager switch --flake .#michaelvessia

.PHONY: force-update
force-update:
	home-manager switch --flake .#michaelvessia -b backup-$(shell date +%Y%m%d-%H%M%S)
	@echo "Checking AppArmor profiles..."
	@~/scripts/generate-apparmor-profiles.sh || echo "Run 'make apparmor' to update AppArmor profiles"

# Update AppArmor profiles for Nix packages
.PHONY: apparmor
apparmor:
	@echo "Updating AppArmor profiles (requires sudo)..."
	@sudo ~/scripts/generate-apparmor-profiles.sh

# Setup Node.js and global npm packages
.PHONY: setup-node
setup-node:
	@echo "Setting up Node.js and global npm packages..."
	@~/scripts/setup-node.sh

# Nix will only clean up after itself when told to, because it purposefully keeps older generations for rollbacks.
.PHONY: clean
clean:
	nix-collect-garbage -d
