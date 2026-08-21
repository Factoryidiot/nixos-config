# ❄️ .nixos

Declarative, reproducible, and stateless multi-host configuration powered by **NixOS Flakes**, **Home Manager**, **Disko**, and **Impermanence**.

---

## 📖 Architecture & Design Principles

This repository manages configurations for personal workstations, gaming laptops, and home servers from a single unified codebase.

- **Stateless Root (Erase Your Darlings):** The root filesystem (`/`) runs entirely in `tmpfs` (RAM). Every reboot wipes the ephemeral state clean, preventing configuration drift and bit rot.
- **Declarative Persistence:** Persistent state (dotfiles, browser profiles, SSH host keys, logs, project files) is explicitly managed via [`impermanence`](https://github.com/nix-community/impermanence) and preserved on dedicated Btrfs subvolumes.
- **Automated Partitioning:** Disk layouts, LUKS2 encryption containers, swapfiles, and Btrfs subvolumes are declaratively defined using [`disko`](https://github.com/nix-community/disko).
- **Hardened Boot Security:** UEFI Secure Boot integration using [`lanzaboote`](https://github.com/nix-community/lanzaboote) with TPM2-backed automated LUKS unlocking (`systemd-cryptenroll`).
- **Secrets Management:** Encrypted secrets using [`agenix`](https://github.com/ryan4yin/ragenix) (`secrets/` directory).
- **Decoupled Dotfiles:** Application dotfiles reside in an external repository (`~/.dotfiles`) and are seamlessly linked into the user environment via Home Manager.

---

## 🖥️ Hosts & Hardware Matrix

| Host | Type & Chassis | CPU | GPU | Memory | Storage Architecture | Target User & Role | Documentation |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [**whio**](file:///home/factory/.nixos/hosts/whio/README.md) | ASUS TUF Gaming A15 (FA507UI) | AMD Ryzen 9 8945H (16T @ 5.26 GHz) | NVIDIA RTX 4070 Mobile + AMD Radeon 780M | 32 GiB DDR5 | 1 TB NVMe SSD (LUKS2 + Btrfs + tmpfs root) | `factory`<br>*(Primary Daily Workstation & Gaming)* | [Specs](file:///home/factory/.nixos/hosts/whio/README.md) • [Install](file:///home/factory/.nixos/hosts/whio/INSTALL.md) • [SecureBoot](file:///home/factory/.nixos/hosts/whio/SECUREBOOT.md) |
| [**kea**](file:///home/factory/.nixos/hosts/kea/README.md) | Dell Gaming Laptop | Intel Core Mobile | Intel HD + NVIDIA GTX 960M (Legacy 580) | 16/32 GiB DDR4 | 240 GB SSD (OS LUKS) + 1 TB HDD (Storage LUKS) | `dexter`<br>*(Secondary Gaming & Portable Rig)* | [Specs](file:///home/factory/.nixos/hosts/kea/README.md) • [Install](file:///home/factory/.nixos/hosts/kea/INSTALL.md) • [SecureBoot](file:///home/factory/.nixos/hosts/kea/SECUREBOOT.md) |
| [**tahi**](file:///home/factory/.nixos/hosts/tahi/README.md) | HPE ProLiant MicroServer Gen10 | AMD Opteron X3418 APU (4C @ 1.8 GHz) | AMD Radeon R5/R6/R7 (Integrated) | 30 GiB DDR4 ECC | 240 GB SSD (OS) + 4x 6 TB HDD (ZFS Pool / NAS) | `factory`<br>*(Headless Hypervisor, NAS & Server)* | [Specs](file:///home/factory/.nixos/hosts/tahi/README.md) • [Install](file:///home/factory/.nixos/hosts/tahi/INSTALL.md) |

---

### Host Summaries

#### 1. [`whio`](file:///home/factory/.nixos/hosts/whio/README.md) — Primary Workstation & Gaming Laptop
- **Chassis:** ASUS TUF Gaming A15 (FA507UI)
- **Primary Use:** Daily driver workstation, software development, LLM tooling, and gaming.
- **Desktop Environment:** Hyprland (Wayland), Ghostty terminal, Waybar, Walker launcher, SwayOSD, Mako notifications.
- **Hardware Integration:** ASUS WMI daemon (`asusd`), NVIDIA PRIME offload graphics switching, Lanzaboote Secure Boot + TPM2 LUKS auto-unlock.
- 🔗 **Guides:** [Hardware Specs](file:///home/factory/.nixos/hosts/whio/README.md) | [Installation Guide](file:///home/factory/.nixos/hosts/whio/INSTALL.md) | [Secure Boot Setup](file:///home/factory/.nixos/hosts/whio/SECUREBOOT.md)

#### 2. [`kea`](file:///home/factory/.nixos/hosts/kea/README.md) — Dual-Drive Gaming Laptop
- **Chassis:** Dell Gaming Laptop
- **Primary Use:** Portable gaming and workstation rig for user `dexter`.
- **Storage Strategy:** Tiered dual-drive layout:
  - **SSD (`/dev/sda`):** High-speed LUKS2 Btrfs container for OS, Nix store, tmpfs root, swapfile, and active configuration.
  - **HDD (`/dev/sdb`):** High-capacity LUKS2 Btrfs storage (`/storage`) with `zstd:3` compression for Steam library, games, VMs, and downloads.
- **Hardware Integration:** Dell SMBIOS battery charge limiting (50–80% thresholds), Intel `thermald`, NVIDIA legacy driver (`legacy_580`) with PRIME offload.
- 🔗 **Guides:** [Hardware Specs](file:///home/factory/.nixos/hosts/kea/README.md) | [Installation Guide](file:///home/factory/.nixos/hosts/kea/INSTALL.md) | [Secure Boot Setup](file:///home/factory/.nixos/hosts/kea/SECUREBOOT.md)

#### 3. [`tahi`](file:///home/factory/.nixos/hosts/tahi/README.md) — Headless Server, NAS & Hypervisor
- **Chassis:** HPE ProLiant MicroServer Gen10 (Rev B)
- **Primary Use:** 24/7 Home server, Incus container/VM virtualization, ZFS/NFS network storage, LLM inference agent host.
- **Network Configuration:** Static bridged network interface (`br0` on `172.16.1.200/24`) with `systemd-networkd` and `nftables`.
- **Storage Strategy:** Fast SATA SSD for OS and stateless runtime + 4x 6 TB enterprise storage drives configured for ZFS pools and NFS shares.
- 🔗 **Guides:** [Hardware Specs](file:///home/factory/.nixos/hosts/tahi/README.md) | [Installation Guide](file:///home/factory/.nixos/hosts/tahi/INSTALL.md)

---

## 📁 Repository Layout

```
.nixos/
├── flake.nix                  # Flake entry point (inputs, outputs, nixosConfigurations)
├── flake.lock                 # Flake input lockfile
├── GEMINI.md                  # Development guidelines & architecture rules
├── README.md                  # Global documentation & hosts matrix
├── hosts/                     # Machine-specific configurations
│   ├── whio/                  # ASUS TUF Gaming A15 laptop
│   │   ├── default.nix        # System configuration & imported modules
│   │   ├── disko.nix          # Declarative disk partitioning (single NVMe)
│   │   ├── hardware-configuration.nix
│   │   ├── persistence.nix    # Impermanence paths
│   │   ├── README.md          # Granular hardware & disk specs
│   │   ├── INSTALL.md         # Step-by-step install guide
│   │   └── SECUREBOOT.md      # Secure Boot & TPM2 auto-unlock guide
│   ├── kea/                   # Dell laptop (dual drive)
│   │   ├── default.nix
│   │   ├── disko.nix          # Dual-drive partitioning (SSD + HDD)
│   │   ├── hardware-configuration.nix
│   │   ├── persistence.nix
│   │   ├── README.md          # Granular hardware & disk specs
│   │   ├── INSTALL.md         # Step-by-step install guide
│   │   └── SECUREBOOT.md      # Dual-drive Secure Boot & TPM2 guide
│   └── tahi/                  # HPE ProLiant MicroServer Gen10
│       ├── default.nix
│       ├── disko.nix          # Server disk partitioning
│       ├── hardware-configuration.nix
│       ├── persistence.nix
│       ├── README.md          # Granular server & storage specs
│       └── INSTALL.md         # Server install guide & SSH bootstrap
├── lib/                       # Reusable modules
│   ├── nixos/                 # System-level modules (NVIDIA, Btrfs, ASUS, Dell, Incus, etc.)
│   └── home/                  # User-level modules (Hyprland, Waybar, Nixvim, Shell, etc.)
├── users/                     # User home-manager configurations
│   ├── factory/               # Workstation / Server user
│   └── dexter/                # Laptop user
└── secrets/                   # Encrypted agenix secrets
```

---

## ⚡ Common Operations & Workflow

### Rebuilding & Switching Configurations

```bash
# Rebuild and switch current machine (auto-detects hostname)
sudo nixos-rebuild switch --flake ~/.nixos

# Rebuild a specific target host
sudo nixos-rebuild switch --flake ~/.nixos#whio
sudo nixos-rebuild switch --flake ~/.nixos#kea
sudo nixos-rebuild switch --flake ~/.nixos#tahi

# Build without activating (useful for testing)
nixos-rebuild build --flake ~/.nixos#whio
```

### Checking & Formatting

```bash
# Evaluate and validate flake checks
nix flake check

# Format all Nix files according to repository guidelines
nix fmt
```

### Updating Flake Inputs

```bash
# Update all inputs
nix flake update

# Update a single input (e.g. nixpkgs, hyprland)
nix flake lock --update-input nixpkgs
```

---

## 📋 Roadmap & To-Do List

### 🔒 Security & Secrets
- [ ] **Agenix Consolidation:** Migrate remaining plain credential files to encrypted `agenix` secrets.
- [ ] **YubiKey / FIDO2 Authentication:** Implement declarative PAM support for hardware security keys on login and `sudo`.
- [ ] **Automated Key Backup:** Create automated, encrypted offline backup scripts for Secure Boot and LUKS recovery keys.

### 🖥️ Host & Hardware Optimization
- [ ] **ASUS ROG/TUF Fine-Tuning (`whio`):** Declaratively configure custom fan curves and battery charge threshold via `asusd` and `supergfxctl`.
- [ ] **Dell Power & Thermals (`kea`):** Calibrate `thermald` XML profiles and TLP power governors for optimal battery vs. gaming performance.
- [ ] **Incus Container Templates (`tahi`):** Automate NixOS and Alpine microVM / container image provisioning on Incus.
- [ ] **ZFS Scrubbing & Health Monitoring (`tahi`):** Set up automated scheduled ZFS scrubs with systemd health check notifications.

### 🎨 Desktop & User Environment
- [ ] **Walker Plugins:** Add custom Walker plugins for systemd service management and clipboard history filtering.
- [ ] **Waybar Modules:** Add dynamic GPU temperature, battery threshold, and network throughput monitors.
- [ ] **Ghostty & Nixvim Sync:** Complete color scheme and keymap harmonization between terminal and editor.

### 📦 Dotfiles & Tooling
- [ ] **Dotfiles Symlink Verification:** Add a validation script to verify all expected `~/.dotfiles` symlinks on fresh installations.
- [ ] **LLM Agent Sidecars:** Expand local Ollama and agent toolchain integrations across workstation and server.

---

## 🚀 Installation

For detailed, host-specific installation steps, partition commands, UUID helpers, and post-installation workflows, refer to each host's dedicated guide:

- 📖 [**whio Installation Guide**](file:///home/factory/.nixos/hosts/whio/INSTALL.md)
- 📖 [**kea Installation Guide**](file:///home/factory/.nixos/hosts/kea/INSTALL.md)
- 📖 [**tahi Installation Guide**](file:///home/factory/.nixos/hosts/tahi/INSTALL.md)
