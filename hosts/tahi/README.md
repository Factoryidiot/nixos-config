# 🖥️ tahi — Hardware Specifications & Architecture

`tahi` is a dedicated 24/7 headless home server, hypervisor, and NAS running on an **HPE ProLiant MicroServer Gen10**, configured for container virtualization (Incus), network storage (ZFS/NFS), and LLM agent orchestration.

---

## ⚙️ Hardware Specifications

| Component | Specification | Details / Notes |
| :--- | :--- | :--- |
| **Chassis / Model** | HPE ProLiant MicroServer Gen10 (Rev B) | Ultra-compact 4-bay enterprise home server |
| **Processor (CPU)** | AMD Opteron X3418 APU | 4 Cores / 4 Threads @ 1.8 GHz (Turbo up to 3.2 GHz) |
| **Graphics (iGPU)** | AMD Radeon R5/R6/R7 (Wani) | Integrated low-power display output |
| **Memory (RAM)** | 30 GiB DDR4 ECC | High-reliability ECC memory for virtualization & ZFS |
| **Network Interfaces** | 2 × Broadcom Gigabit Ethernet | Configured with bridge `br0` (`enp2s0f0`) on `172.16.1.200/24` |
| **Primary OS Storage** | 240 GB SATA SSD (ADATA SU630, `/dev/sda`) | Dedicated OS, Btrfs subvolumes, and stateless root |
| **Storage Array** | 4 × 6 TB Western Digital Red HDDs | `/dev/sdb`, `/dev/sdc`, `/dev/sdd`, `/dev/sde` (~24 TB raw storage) |
| **Server Role** | Headless Hypervisor & Storage Server | Incus virtualization, NFS exports, LLM agents |

---

## 🌐 Network Configuration

The network stack is managed via `systemd-networkd` with `nftables`:

- **Bridge Interface:** `br0` (bridged on physical interface `enp2s0f0`)
- **Static IPv4 Address:** `172.16.1.200/24`
- **Default Gateway:** `172.16.1.1`
- **Nameservers:** `1.1.1.2` (Cloudflare Security), `9.9.9.9` (Quad9)
- **MAC Address:** `d4:c9:ef:ce:e1:6e`
- **Firewall:** `br0` marked as trusted for local container routing and virtual bridge interfaces.

---

## 💽 Storage & Filesystem Architecture

```
Drive 1: /dev/sda (240 GB SATA SSD - OS Drive)
├── /dev/sda1 (500 MiB FAT32) ───────────────────── /boot (EFI System Partition)
└── /dev/sda2 (Rest of Drive, Btrfs)
    ├── / (tmpfs, 8 GiB RAM) ────────────────────── Ephemeral stateless root
    ├── subvol=@nix ──────────────────────────────── /nix (Nix Store, zstd:1)
    ├── subvol=@persistent ───────────────────────── /persistent (System & user persistent state)
    ├── subvol=swap ──────────────────────────────── /swap (24 GiB swapfile)
    ├── subvol=@tmp ──────────────────────────────── /tmp (Temporary files)
    ├── subvol=@guix ─────────────────────────────── /gnu (Guix compatibility layer)
    ├── subvol=@snapshots ────────────────────────── /snapshots (Snapper snapshots)
    └── subvolid=5 ───────────────────────────────── /btr_pool

Drives 2-5: /dev/sdb .. /dev/sde (4x 6 TB Storage Array)
└── ZFS Storage Pool / NFS Shares
    ├── NFS /mnt/pve/tahinas_game_servers
    ├── NFS /mnt/pve/truenas_backups
    └── NFS /mnt/pve/truenas_isos
```

### Mountpoints & Purpose

| Mountpoint | Device / Subvolume | FS Type | Mount Options | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `/` | `tmpfs` | `tmpfs` | `relatime,mode=755,size=8G` | Ephemeral stateless root |
| `/boot` | `/dev/sda1` | `vfat` | `fmask=0077,dmask=0077` | Bootloader & kernel |
| `/nix` | `/dev/sda2` (`@nix`) | `btrfs` | `noatime,compress=zstd:1,ssd,discard=async` | Nix package store |
| `/persistent` | `/dev/sda2` (`@persistent`) | `btrfs` | `noatime,compress=zstd:1,ssd,discard=async` | Preserved server state & SSH keys |
| `/swap` | `/dev/sda2` (`swap`) | `btrfs` | `noatime,nodatacow` | 24 GiB swapfile |
| `/tmp` | `/dev/sda2` (`@tmp`) | `btrfs` | `noatime,compress=zstd:1,ssd,discard=async` | Transient files |

---

## 🖥️ Software Environment & Services

- **Target User:** `factory` (Server mode, `isServer = true`)
- **Kernel:** Linux Long-Term Support Kernel (`pkgs.linuxPackages_6_12`) with `amd_pstate=active`
- **Virtualization:** **Incus** container & VM hypervisor with bridge networking
- **NAS & Storage:** ZFS support, NFS server exports, and automated maintenance timers
- **Remote Access:** OpenSSH daemon with key-only authentication (`PermitRootLogin = prohibit-password`, `PasswordAuthentication = false`)
- **LLM Infrastructure:** Local inference tooling and LLM agent services

---

## 🔗 Related Documentation

- 📖 [**tahi Installation Guide**](file:///home/factory/.nixos/hosts/tahi/INSTALL.md) — Headless server installation and SSH bootstrap runbook.
