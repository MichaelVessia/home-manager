.PHONY: update
update:
	home-manager switch --flake .#michaelvessia
	@echo "Checking AppArmor profiles..."
	@./scripts/generate-apparmor-profiles.sh || echo "Run 'make apparmor' to update AppArmor profiles"

# Update AppArmor profiles for Nix packages
.PHONY: apparmor
apparmor:
	@echo "Updating AppArmor profiles (requires sudo)..."
	@sudo ./scripts/generate-apparmor-profiles.sh

# Nix will only clean up after itself when told to, because it purposefully keeps older generations for rollbacks.
.PHONY: clean
clean:
	nix-collect-garbage -d
