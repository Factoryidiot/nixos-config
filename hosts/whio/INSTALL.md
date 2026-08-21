# 🛠️ whio — NixOS Installation Guide

This document provides a step-by-step runbook for performing a fresh, clean installation of NixOS on the **`whio`** host (ASUS TUF Gaming A15) using Disko, Impermanence, and Btrfs.

---

## 📋 Host Overview

- **Host Target:** `whio`
- **Primary User:** `factory`
- **Target Drive:** `/dev/nvme0n1` (1 TB NVMe SSD)
- **Encryption:** LUKS2 (`crypted`)
- **Filesystem:** Btrfs with `tmpfs` stateless root

---

## 🚀 Installation Runbook

### Step 1: Boot & Elevate to Root

1. Boot into the latest NixOS Minimal or Graphical Live ISO.
2. Open a terminal and elevate to a root shell:
   ```bash
   sudo -i
   ```
3. Ensure network connectivity:
   ```bash
   ping -c 3 nixos.org
   ```

---

### Step 2: Clone Configuration Repository

Clone this configuration repository to a temporary location:

```bash
git clone https://github.com/factoryidiot/.nixos.git ~/.nixos
cd ~/.nixos
```

---

### Step 3: Prepare Disk with Disko

1. Execute the automated Disko partitioning script for `whio`:
   ```bash
   nix --experimental-features "nix-command flakes" \
     run github:nix-community/disko/latest -- \
     --mode disko \
     ./hosts/whio/disko.nix
   ```

   > [!TIP]
   > Disko will partition `/dev/nvme0n1`, create the LUKS2 container (`crypted`), create all Btrfs subvolumes (`@nix`, `@persistent`, `@swap`, `@tmp`, `@guix`, `@snapshots`), and mount the hierarchy under `/mnt`.

2. Enable and verify the swapfile:
   ```bash
   swapon /mnt/swap/swapfile
   swapon -s
   ```

   > [!NOTE]
   > Verify that Copy-on-Write (CoW) is disabled on the swapfile:
   > `lsattr /mnt/swap/swapfile` should display `---------------C------ /mnt/swap/swapfile`.

3. Verify active mounts:
   ```bash
   lsblk
   df -h
   ```

---

### Step 4: Generate Hardware UUIDs

1. Generate standard NixOS configuration templates:
   ```bash
   nixos-generate-config --root /mnt
   ```

2. Export the partition and filesystem UUIDs directly into a helper file `hosts/whio/UUID`:
   ```bash
   cat <<EOF > hosts/whio/UUID
     BOOT_ESP_UUID  = "$(blkid -s UUID -o value /dev/nvme0n1p1)"; # /dev/nvme0n1p1 (FAT32 EFI partition)
     NVME_LUKS_UUID = "$(blkid -s UUID -o value /dev/nvme0n1p2)"; # /dev/nvme0n1p2 (LUKS partition on NVMe)
     BTRFS_UUID     = "$(blkid -s UUID -o value /dev/mapper/crypted)"; # /dev/mapper/crypted (Decrypted BTRFS filesystem)
   EOF
   cat hosts/whio/UUID
   ```

3. Update the `let` block in [`hosts/whio/hardware-configuration.nix`](file:///home/factory/.nixos/hosts/whio/hardware-configuration.nix) to match the UUIDs generated above.

4. Remove the temporary template directory:
   ```bash
   rm -rf /mnt/etc/nixos/*
   ```

---

### Step 5: Execute NixOS Installation

1. Stage local changes in git if any files were edited:
   ```bash
   git add .
   ```

2. Run the NixOS installer targeting `whio`:
   ```bash
   nixos-install --root /mnt --no-root-password --flake .#whio --no-write-lock-file
   ```

   > [!TIP]
   > If evaluation issues occur, append `--show-trace --verbose` for detailed stack traces.

---

### Step 6: Post-Installation Persistence Setup

Before rebooting, prepare the persistent directories so essential services and configurations survive the stateless tmpfs reboot:

1. Create persistent directory structure for the user:
   ```bash
   mkdir -p /mnt/persistent/home/factory/.nixos
   mkdir -p /mnt/persistent/etc
   ```

2. Move generated host SSH keys to persistent storage:
   ```bash
   mv /mnt/etc/ssh /mnt/persistent/etc/
   ```

3. Copy the repository to persistent user storage:
   ```bash
   cp -r ~/.nixos/* ~/.nixos/.* /mnt/persistent/home/factory/.nixos/ 2>/dev/null || cp -r ~/.nixos /mnt/persistent/home/factory/
   ```

4. Set proper file ownership (`1000:100` for user `factory`):
   ```bash
   chown -R 1000:100 /mnt/persistent/home/factory
   ```

---

### Step 7: Reboot & Boot Security Setup

1. Reboot the system into the newly installed NixOS:
   ```bash
   reboot
   ```

2. After logging into `whio`, follow the [**whio Secure Boot & TPM2 Guide**](file:///home/factory/.nixos/hosts/whio/SECUREBOOT.md) to:
   - Enroll Secure Boot keys using `sbctl`.
   - Enroll the TPM2 security chip for automatic LUKS decryption.
