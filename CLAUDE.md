# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a cross-platform Home Manager configuration for user `michaelvessia` (Linux) / `michael.vessia` (macOS) using Nix Flakes. It provides declarative user environment management with a modular architecture supporting both Linux and macOS systems.

## Important: Command Execution Policy

**NEVER run any make commands, home-manager commands, or nix commands. The user will handle all command execution themselves.**

## Architecture

### Core Structure
- `flake.nix` - Main flake configuration with cross-platform support
- `hosts/` - Host-specific configurations
  - `darwin-work.nix` - macOS work configuration
  - `linux-home.nix` - Linux home configuration  
- `modules/` - Modular platform-specific configurations
  - `common/` - Shared configurations across platforms
  - `darwin/` - macOS-specific modules (Homebrew, system settings)
  - `linux/` - Linux-specific modules (AppArmor, GNOME)
- `packages/` - Individual application configurations
- `lib/` - Utility functions and platform detection
- `scripts/` - Utility scripts for setup and maintenance

### Key Configuration Features
- **Cross-Platform Support**: Unified configuration for Linux and macOS
- **Hybrid Dotfiles**: Uses both Home Manager (packages) and Chezmoi (dotfiles from separate repo)
- **Modular Design**: Platform-specific modules with shared common configurations
- **macOS Integration**: Homebrew package management and system configuration
- **Linux Security**: Custom AppArmor profiles for Nix-installed applications
- **Development Environment**: Neovim, Fish shell, Ghostty terminal, Node.js tooling

### Platform-Specific Features
**Linux:**
- GNOME desktop customization with dconf settings and extensions
- AppArmor security profiles
- Username: `michaelvessia`

**macOS:**
- Homebrew package management with security-focused configuration
- Karabiner Elements for keyboard customization
- Username: `michael.vessia` (different from Linux)

### Important Files
- `flake.nix:39-51` - Cross-platform Home Manager configurations
- `hosts/darwin-work.nix` - macOS-specific configuration and imports
- `hosts/linux-home.nix` - Linux-specific configuration and imports
- `modules/darwin/brew.nix` - Homebrew package management
- `lib/platform.nix` - Platform detection utilities

## Development Workflow

### Adding New Packages
1. Create `packages/<package-name>/<package-name>.nix`
2. Add import to appropriate host configuration in `hosts/`
3. User applies changes with platform-specific commands

### System Configuration
- **Supported Systems**: `x86_64-linux`, `aarch64-darwin`, `x86_64-darwin`
- **NixOS/nixpkgs version**: `25.05`
- **Home Manager version**: `release-25.05`

### External Dependencies
- **Chezmoi**: Manages detailed dotfiles from `git@github.com:MichaelVessia/dots.git`
- **Homebrew** (macOS): GUI applications and system tools
- **Node.js tooling**: Development environment setup