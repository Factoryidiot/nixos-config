# 🛠️ kea — NixOS Installation Guide

This document provides a complete installation runbook for **`kea`** (Dell Gaming Laptop), configuring its **dual-drive** storage architecture (`/dev/sda` SSD for OS and `/dev/sdb` HDD for bulk storage) with LUKS2 encryption and Impermanence.

---

## 📋 Host Overview

- **Host Target:** `kea`
- **Primary User:** `dexter`
- **Drives:**
  - `/dev/sda` (~240 GB Fast SSD) → `/boot` (ESP) + LUKS2 (`crypted_ssd`) → Btrfs (`/`, `/nix`, `/persistent`, `/swap`, `/tmp`, `/gnu`, `/snapshots`)
  - `/dev/sdb` (~1 TB Storage HDD) → LUKS2 (`crypted_storage`) → Btrfs (`/storage` for Games, Steam, Videos, VMs, Downloads)

---

## 🚀 Installation Runbook

### Step 1: Boot & Elevate to Root

1. Boot into the NixOS Live ISO on `kea`.
2. Open a terminal and switch to root:
   ```bash
   sudo -i
   ```
3. Verify internet connectivity:
   ```bash
   ping -c 3 nixos.org
   ```

---

### Step 2: Clone Configuration Repository

```bash
git clone https://github.com/factoryidiot/.nixos.git ~/.nixos
cd ~/.nixos
```

---

### Step 3: Prepare Dual Disks with Disko

1. Run Disko partitioning targeting `kea`:
   ```bash
   nix --experimental-features "nix-command flakes" \
     run github:nix-community/disko/latest -- \
     --mode disko \
     ./hosts/kea/disko.nix
   ```

   > [!TIP]
   > Disko will format both `/dev/sda` and `/dev/sdb`, create LUKS2 encrypted containers (`crypted_ssd` and `crypted_storage`), construct all Btrfs subvolumes, and mount `/mnt` and `/mnt/storage`.

2. Enable and verify the swapfile:
   ```bash
   swapon /mnt/swap/swapfile
   swapon -s
   ```

3. Verify both storage mounts:
   ```bash
   lsblk
   df -h
   ```
   Confirm `/mnt`, `/mnt/boot`, `/mnt/nix`, `/mnt/persistent`, `/mnt/storage`, and `/mnt/tmp` are mounted.

---

### Step 4: Generate Hardware UUIDs

1. Generate hardware configuration scan:
   ```bash
   nixos-generate-config --root /mnt
   ```

2. Export all 5 UUIDs directly into `hosts/kea/UUID`:
   ```bash
   cat <<EOF > hosts/kea/UUID
     BOOT_ESP_UUID   = "$(blkid -s UUID -o value /dev/sda1)"; # /dev/sda1 (FAT32 EFI partition)
     SSD_LUKS_UUID   = "$(blkid -s UUID -o value /dev/sda2)"; # /dev/sda2 (LUKS partition on SSD)
     HDD_LUKS_UUID   = "$(blkid -s UUID -o value /dev/sdb1)"; # /dev/sdb1 (LUKS partition on Storage)
     SSD_BTRFS_UUID  = "$(blkid -s UUID -o value /dev/mapper/crypted_ssd)"; # /dev/mapper/crypted_ssd (Decrypted SSD Btrfs)
     HDD_BTRFS_UUID  = "$(blkid -s UUID -o value /dev/mapper/crypted_storage)"; # /dev/mapper/crypted_storage (Decrypted Storage Btrfs)
   EOF
   cat hosts/kea/UUID
   ```

3. Update the `let` block in [`hosts/kea/hardware-configuration.nix`](file:///home/factory/.nixos/hosts/kea/hardware-configuration.nix) with the UUID values.

4. Remove the temporary template directory:
   ```bash
   rm -rf /mnt/etc/nixos/*
   ```

---

### Step 5: Execute NixOS Installation

1. Stage local changes:
   ```bash
   git add .
   ```

2. Run the NixOS installer targeting `kea`:
   ```bash
   nixos-install --root /mnt --no-root-password --flake .#kea --no-write-lock-file
   ```

---

### Step 6: Post-Installation Persistence Setup

Create persistent paths across both the SSD and storage drive:

1. Create persistent directory structure for user `dexter`:
   ```bash
   mkdir -p /mnt/persistent/home/dexter/.nixos
   mkdir -p /mnt/persistent/etc
   mkdir -p /mnt/storage/home/dexter
   ```

2. Move generated SSH host keys:
   ```bash
   mv /mnt/etc/ssh /mnt/persistent/etc/
   ```

3. Copy the configuration repository to persistent storage:
   ```bash
   cp -r ~/.nixos/* ~/.nixos/.* /mnt/persistent/home/dexter/.nixos/ 2>/dev/null || cp -r ~/.nixos /mnt/persistent/home/dexter/
   ```

4. Set proper user ownership (`1000:100` for user `dexter`):
   ```bash
   chown -R 1000:100 /mnt/persistent/home/dexter
   chown -R 1000:100 /mnt/storage/home/dexter
   ```

---

### Step 7: Reboot & Boot Security Setup

1. Reboot the system:
   ```bash
   reboot
   ```

2. Follow the [**kea Secure Boot & TPM2 Guide**](file:///home/factory/.nixos/hosts/kea/SECUREBOOT.md) to enroll Secure Boot and configure automated TPM2 unlocking for **both** `/dev/sda2` and `/dev/sdb1`.
