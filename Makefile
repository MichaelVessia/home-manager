.PHONY: update
update:
	home-manager switch --flake .#michaelvessia

# Nix will only clean up after itself when told to, because it purposefully keeps older generations for rollbacks.
.PHONY: clean
clean:
	nix-collect-garbage -d
