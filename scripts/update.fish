#!/usr/bin/env fish

function update
    if test (uname) = "Darwin"
        echo "Updating Darwin system configuration..."
        sudo darwin-rebuild switch --flake ~/home-manager#work-mac
        and echo "Updating Home Manager configuration..."
        and home-manager switch --flake ~/home-manager#michaelvessia@darwin
    else
        echo "Updating Home Manager configuration..."
        home-manager switch --flake ~/home-manager#michaelvessia@linux
    end
end