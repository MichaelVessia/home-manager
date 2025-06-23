#!/usr/bin/env bash

set -euo pipefail

echo "Setting up Node.js and global npm packages..."

# Check if volta is available
if ! command -v volta &> /dev/null; then
    echo "Error: volta not found in PATH"
    exit 1
fi

# Install latest Node.js LTS via volta if not already installed
if ! volta list node | grep -q "node@"; then
    echo "Installing latest Node.js LTS via volta..."
    volta install node@latest
else
    echo "Node.js already installed via volta"
fi

# List of global npm packages to install
GLOBAL_PACKAGES=(
    "@anthropic-ai/claude-code"
)

echo "Checking global npm packages..."
for package in "${GLOBAL_PACKAGES[@]}"; do
    if npm list -g "$package" &> /dev/null; then
        echo "$package is already installed globally"
    else
        echo "Installing $package..."
        npm install -g "$package"
    fi
done

echo "Node.js setup complete!"
echo "Installed Node version: $(node --version)"
echo "Installed npm version: $(npm --version)"