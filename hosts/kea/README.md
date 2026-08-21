# 💻 kea — Hardware Specifications & Architecture

`kea` is a secondary gaming laptop and portable workstation configured for user **`dexter`**, featuring a high-efficiency tiered dual-drive storage architecture (SSD + HDD), Intel/NVIDIA hybrid graphics, and stateless root on `tmpfs`.

---

## ⚙️ Hardware Specifications

| Component | Specification | Details / Notes |
| :--- | :--- | :--- |
| **Chassis / Model** | Dell Laptop | High-durability dual-drive laptop chassis |
| **Processor (CPU)** | Intel Core Mobile Processor | Multi-core Intel CPU with `kvm-intel` hardware virtualization |
| **Graphics (dGPU)** | NVIDIA GeForce GTX 960M | Maxwell architecture, NVIDIA proprietary `legacy_580` driver (`PCI:2:0:0`) |
| **Graphics (iGPU)** | Intel HD Graphics | Integrated power-efficient display controller (`PCI:0:2:0`) |
| **Graphics Switching** | NVIDIA PRIME Offload | Dynamic GPU offloading via `nvidia-offload` script |
| **Primary Storage (SSD)** | ~240 GB SATA / M.2 SSD (`/dev/sda`) | High-speed OS, Nix store, and persistent configuration container |
| **Secondary Storage (HDD)** | ~1 TB Mechanical / Bulk Drive (`/dev/sdb`) | Encrypted bulk storage partition for games, media, and VMs |
| **Power & Thermals** | Dell SMBIOS & Intel Thermald | Battery charge limiting (50–80% threshold) and thermal throttling protection |
| **Security Hardware** | TPM 2.0 Module | Hardware-backed key enrollment for Secure Boot & dual-drive LUKS unlocking |

---

## 💽 Storage & Tiered Filesystem Architecture

`kea` leverages a tiered dual-drive layout managed via [`disko`](file:///home/factory/.nixos/hosts/kea/disko.nix). Both drives are fully encrypted with LUKS2 and formatted as Btrfs filesystems.

```
Drive 1: /dev/sda (~240 GB Fast SSD)
├── /dev/sda1 (512 MiB FAT32) ───────────────────── /boot (EFI System Partition)
└── /dev/sda2 (Rest of Drive, LUKS2: crypted_ssd)
    └── Btrfs OS Pool
        ├── / (tmpfs in RAM) ────────────────────── Ephemeral stateless root
        ├── subvol=@nix ──────────────────────────── /nix (Nix Store, zstd:1, ssd, discard=async)
        ├── subvol=@persistent ───────────────────── /persistent (Dotfiles, system state, fast IO)
        ├── subvol=@swap ─────────────────────────── /swap (24 GiB swapfile, nodatacow)
        ├── subvol=@tmp ──────────────────────────── /tmp (Transient build directory)
        ├── subvol=@guix ─────────────────────────── /gnu (Guix compatibility layer)
        ├── subvol=@snapshots ────────────────────── /snapshots (Snapper snapshots)
        └── subvolid=5 ───────────────────────────── /btr_pool

Drive 2: /dev/sdb (~1 TB Storage HDD)
└── /dev/sdb1 (Full Drive, LUKS2: crypted_storage)
    └── Btrfs Bulk Storage Pool
        ├── subvol=@storage ──────────────────────── /storage (High-compression zstd:3 for games/media)
        └── subvolid=5 ───────────────────────────── /storage_pool
```

### Mountpoints & Purpose

| Mountpoint | Device / Subvolume | FS Type | Mount Options | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `/` | `tmpfs` | `tmpfs` | `relatime,mode=755` | Ephemeral root; wiped clean on reboot |
| `/boot` | `/dev/sda1` | `vfat` | `fmask=0077,dmask=0077` | UEFI bootloader & EFI binaries |
| `/nix` | `crypted_ssd` (`@nix`) | `btrfs` | `noatime,compress=zstd:1,ssd,discard=async` | Nix package store |
| `/persistent` | `crypted_ssd` (`@persistent`) | `btrfs` | `noatime,compress=zstd:1,ssd,discard=async` | Fast user dotfiles, SSH keys, active projects |
| `/swap` | `crypted_ssd` (`@swap`) | `btrfs` | `noatime,nodatacow` | 24 GiB swapfile |
| `/tmp` | `crypted_ssd` (`@tmp`) | `btrfs` | `noatime,compress=zstd:1,ssd,discard=async` | High-speed temporary files |
| `/storage` | `crypted_storage` (`@storage`) | `btrfs` | `noatime,compress=zstd:3` | Large games, Steam library, videos, downloads |

---

## 🖥️ Software Environment & Services

- **Target User:** `dexter`
- **Desktop Environment:** Hyprland (Wayland)
- **Kernel:** Linux Zen Kernel (`pkgs.linuxPackages_zen`)
- **Hardware Integration:**
  - `libsmbios` & `tlp` for Dell battery charging thresholds (`START_CHARGE_THRESH_BAT0 = 50`, `STOP_CHARGE_THRESH_BAT0 = 80`).
  - `thermald` active thermal management.
  - Dedicated storage persistence routing large user directories (`Downloads`, `Videos`, `Games`) directly to `/storage`.

---

## 🔗 Related Documentation

- 📖 [**kea Installation Guide**](file:///home/factory/.nixos/hosts/kea/INSTALL.md) — Dual-drive Disko partitioning and installation runbook.
- 🔒 [**kea Secure Boot & TPM2 Guide**](file:///home/factory/.nixos/hosts/kea/SECUREBOOT.md) — Dual-drive TPM2 auto-unlock and Secure Boot enrollment.
