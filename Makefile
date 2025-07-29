# Platform-specific targets
.PHONY: linux
linux:
	home-manager switch --flake .#michaelvessia@linux

.PHONY: darwin
darwin:
	home-manager switch --flake .#michaelvessia@darwin

# Default target (auto-detect platform)
.PHONY: update
update:
ifeq ($(shell uname),Darwin)
	@$(MAKE) darwin
else
	@$(MAKE) linux
endif

.PHONY: force-update
force-update:
ifeq ($(shell uname),Darwin)
	home-manager switch --flake .#michaelvessia@darwin -b backup-$(shell date +%Y%m%d-%H%M%S)
else
	home-manager switch --flake .#michaelvessia@linux -b backup-$(shell date +%Y%m%d-%H%M%S)
	@echo "Checking AppArmor profiles..."
	@~/scripts/generate-apparmor-profiles.sh || echo "Run 'make apparmor' to update AppArmor profiles"
endif

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
