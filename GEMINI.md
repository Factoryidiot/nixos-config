# Gemini Code Assistant Guidelines

This document provides a comprehensive overview of the `nixos-config` project, its architecture, and development guidelines. The purpose of this file is to maximize the utility of the Gemini CLI for maintaining design consistency and providing accurate feature implementation advice.

## 1. CONTEXT

This project manages NixOS and home-manager configurations for multiple systems and users in a declarative and reproducible way using Nix Flakes.

### Technology Stack

- **Core:** Nix, NixOS, Nix Flakes
- **System Configuration:**
  - `disko`: For declarative disk partitioning.
  - `impermanence`: For managing persistent state on otherwise ephemeral filesystems.
- **Desktop Environment:**
  - **Window Manager:** Hyprland (Wayland compositor)
  - **Shell:** zsh with powerlevel10k
  - **Other Tools:** Waybar, Mako, Walker, etc.
- **Secrets Management:** `agenix` for declarative secret management.

## 2. ARCHITECTURE

The project is structured to separate concerns for hosts, users, and reusable modules.

### Key Directory Structures

- **`flake.nix`**: The entry point of the configuration. It defines the flake's inputs (like `nixpkgs`, `home-manager`, etc.) and outputs (the NixOS configurations for each host).

- **`/hosts`**: Contains the main configuration for each machine. Each host has its own directory (e.g., `/hosts/whio/`) with a `default.nix` that defines the system's configuration by importing modules from `/lib` and specifying host-specific settings.
  - `default.nix`: Main NixOS configuration for the host.
  - `disko.nix`: Declarative disk partitioning using `disko`.
  - `hardware-configuration.nix`: Hardware-specific settings.
  - `persistence.nix`: Defines persistent data using `impermanence`.

- **`/users`**: Contains user-specific configurations. The main entry point for each user is `home.nix` (e.g., `/users/rhys/home.nix`), which defines the user's home-manager configuration.

- **`/lib`**: Contains reusable NixOS and home-manager modules, organized into `nixos` and `home` subdirectories. This is where the bulk of the configuration logic resides.
  - `/lib/nixos/`: Modules for system-level services and packages (e.g., `nvidia.nix`, `secureboot.nix`).
  - `/lib/home/`: Modules for user-level applications and dotfiles (e.g., `git.nix`, `zsh.nix`, `desktop/hyprland.nix`).

- **`/dotfiles`**: Contains the raw configuration files (dotfiles) for various applications. These are linked into the user's home directory by `home-manager` using the `home.file` option. This keeps the actual dotfiles separate from the Nix logic.

- **`/secrets`**: Manages encrypted secrets using `agenix`. `secrets.nix` defines the secrets, and the actual secret files are encrypted and stored in the directory.

- **`/overlays`**: Used to add or modify Nix packages.

### Component Relationships

1.  The `flake.nix` file ties everything together. It builds the NixOS configurations for each host defined in `/hosts`.
2.  Each host configuration in `/hosts` is a NixOS module that imports and configures modules from `/lib/nixos`.
3.  Host configurations also specify which users are on the system, and point to their respective home-manager configurations in `/users`.
4.  User configurations in `/users` import and configure modules from `/lib/home`.
5.  Many of the modules in `/lib/home` manage dotfiles by referring to the files in the `/dotfiles` directory.

## 3. GUIDELINES

Adherence to these guidelines is crucial for maintaining the quality and consistency of the codebase.

### Nix Language and Formatting

- **Formatting:** All Nix code should be formatted using `nixpkgs-fmt`.
- **Modularity:** When adding new functionality, prefer creating a new module in `/lib`. Each module should be self-contained and expose options to configure its behavior.
- **Packages:**
  - To add a package to the system, add it to the `environment.systemPackages` list in a relevant module in `/lib/nixos`.
  - To add a package to a user's profile, add it to the `home.packages` list in a relevant module in `/lib/home`.

### Adding New Applications and Configurations

1.  **Dotfiles:** Add the new application's configuration file(s) to the `/dotfiles` directory.
2.  **Home-manager Module:** Create a new module in `/lib/home` (or `/lib/home/desktop` for GUI apps) to manage the application.
    - This module should have an `enable` option.
    - When enabled, it should:
      - Add the application's package to `home.packages`.
      - Link the configuration file from `/dotfiles` to the correct location in the user's home directory using `home.file`.
3.  **Import Module:** Import the new module into `users/rhys/home.nix` (or a more specific module if appropriate) and enable it.

### Secrets Management

- To add a new secret, use the `agenix` CLI to edit the secrets file. Do not commit unencrypted secrets.
- Refer to secrets in your Nix configuration using `config.age.secrets.<secret_name>.path`.

### Git and Committing

-   Follow conventional commit message standards.
-   Ensure that `nixpkgs-fmt` has been run on your changes before committing.
