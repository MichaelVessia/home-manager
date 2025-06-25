#!/usr/bin/env bash

# Install Docker via system package manager but managed through Nix activation
set -euo pipefail

echo "Installing Docker system-wide..."

# Update package list
sudo apt update

# Install Docker
sudo apt install -y docker.io docker-compose-v2

# Add user to docker group
sudo usermod -aG docker $USER

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Check if user is in docker group after install
if ! groups $USER | grep -q docker; then
    echo "Warning: User not in docker group. Adding now..."
    sudo usermod -aG docker $USER
    echo "Added $USER to docker group."
fi

# Verify Docker is running
if ! systemctl is-active --quiet docker; then
    echo "Starting Docker service..."
    sudo systemctl start docker
fi

echo "Docker installed! Log out and back in to use Docker without sudo."
echo "Or run: newgrp docker"
echo "Test with: docker run hello-world"