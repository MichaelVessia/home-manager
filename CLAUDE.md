# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a NixOS Home Manager configuration for user `michaelvessia` using Nix Flakes. It provides declarative user environment management with a modular architecture where each package/service has its own configuration file.

## Core Commands

### Primary Development Commands
- `make` or `make update` - Apply Home Manager configuration changes
- `make force-update` - Force update with timestamped backup
- `make clean` - Clean up old Nix generations to free disk space
- `make apparmor` - Update AppArmor security profiles (requires sudo)
- `make setup-node` - Setup Node.js and global npm packages

### Manual Commands
- `home-manager switch --flake .#michaelvessia` - Apply configuration directly
- `nix-collect-garbage -d` - Clean up old Nix generations

## Architecture

### Core Structure
- `flake.nix` - Main flake configuration defining inputs and outputs
- `home.nix` - Central configuration file that imports all package modules
- `packages/` - Modular package configurations, each in its own directory
- `scripts/` - Utility scripts for setup and maintenance

### Key Configuration Features
- **Hybrid Dotfiles**: Uses both Home Manager (packages) and Chezmoi (dotfiles from separate repo)
- **Modular Design**: Each application has its own `.nix` file in `packages/`
- **Security**: Custom AppArmor profiles for Nix-installed applications
- **GNOME Customization**: Extensive dconf settings and extensions
- **Development Environment**: Neovim, Fish shell, Ghostty terminal, Volta for Node.js

### Package Structure
Each package module follows the pattern:
```
packages/<package-name>/<package-name>.nix
```

### Important Files
- `home.nix:8-33` - All package imports (add new packages here)
- `home.nix:45-49` - Global environment variables
- `home.nix:56-62` - Chezmoi integration for dotfiles
- `home.nix:64-81` - SSH key generation automation

## Development Workflow

### Adding New Packages
1. Create `packages/<package-name>/<package-name>.nix`
2. Add import to `home.nix` imports list
3. Run `make` to apply changes

### System Configuration
- Target system: `x86_64-linux`
- NixOS version: `25.05`
- Home Manager version: `release-25.05`
- User: `michaelvessia`

### Special Directories
- `~/scripts/` - Utility scripts (automatically made executable)
- Aliases: `hm` (this directory), `dots` (chezmoi dotfiles)

## Integration Points

### External Dependencies
- **Chezmoi**: Manages detailed dotfiles from `git@github.com:MichaelVessia/dots.git`
- **Volta**: Node.js version management
- **AppArmor**: Security profiles for applications
- **GNOME**: Desktop environment with custom settings

### Automated Setup
- SSH key generation (ED25519) if missing
- Chezmoi initialization and updates
- Fish shell auto-start from bash
- AppArmor profile updates

## Testing & Validation

Always test configuration changes with:
```bash
make update
```

For major changes, use:
```bash
make force-update
```

No specific test framework - validation is done through successful Home Manager switch operations.