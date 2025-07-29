#!/usr/bin/env bash

set -euo pipefail

echo "Setting up Node.js and global npm packages using mise..."

# Check if mise is available
if ! command -v mise &> /dev/null; then
    echo "Error: mise not found in PATH"
    echo "Run 'make darwin' first to install mise"
    exit 1
fi

# Install latest Node.js LTS via mise if not already installed
if ! mise list node 2>/dev/null | grep -q "node"; then
    echo "Installing latest Node.js LTS via mise..."
    mise use -g node@lts
else
    echo "Node.js already installed via mise"
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
echo ""
echo "To use different Node versions in projects:"
echo "  mise use node@18    # Use Node 18 in current project"
echo "  mise use node@20    # Use Node 20 in current project"