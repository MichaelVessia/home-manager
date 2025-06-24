# Home Manager Configuration

This repository contains my [Home Manager](https://github.com/nix-community/home-manager) configuration for declarative user environment management on NixOS/Linux systems.

## Structure

```
.
├── home.nix              # Main configuration entry point
├── packages/             # Modular package configurations
│   └── */                # Individual package modules
└── README.md
```

## Overview

This configuration uses a modular approach where each package or service has its own dedicated `.nix` file in the `packages/` directory. The main `home.nix` file imports these modules to compose the complete user environment.

## Dotfiles Management

Some configuration files (dotfiles) are managed separately using [chezmoi](https://www.chezmoi.io/) in another repository. This hybrid approach allows for:
- Separation of concerns between package installation and configuration
- Easier dotfile sharing across different systems and operating systems
- Template-based configuration management
- **Cross-platform compatibility**: Chezmoi handles dotfiles for systems where home-manager isn't available or practical (e.g., macOS, work environments, systems where Nix isn't installed)

## Usage

To apply changes:
```bash
make
```

See the [Makefile](./Makefile) for all available commands including force updates, cleanup, and maintenance tasks.

## Directory Navigation

For convenience, the following aliases are configured:
- `hm` - Navigate to this home-manager directory
- `dots` - Navigate to the chezmoi-managed dotfiles

## Contributing

When adding new packages:
1. Create a new module in `packages/<package-name>/<package-name>.nix`
2. Import the module in `home.nix`
3. Follow the existing structure and conventions