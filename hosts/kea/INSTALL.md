# kea - NixOS Installation Guide
[[SECUREBOOT]]

## Host Overview
**Host:** `kea`  
**User:** `dexter`  
**Drives:**
- `/dev/sda` (~232.9 GB SSD) → `/boot` (ESP), LUKS (`crypted_ssd`) → BTRFS (`/`, `/nix`, `/persistent`, `/swap`, `/tmp`, `/gnu`, `/snapshots`)
- `/dev/sdb` (~931.5 GB Storage) → LUKS (`crypted_storage`) → BTRFS (`/storage` for Games, Steam, Videos, VMs, Downloads via Impermanence)

---

## Installation Process

### 1. Prerequisites
1. Open a root shell on the NixOS live environment:
   ```sh
   sudo -i
   ```
2. Clone the repository:
   ```sh
   git clone https://github.com/your-username/nixos-config.git
   cd nixos-config
   ```

---

### 2. Prepare Disks with Disko
1. Execute Disko partitioning for `kea`:
   ```sh
   nix --experimental-features "nix-command flakes" \
     run github:nix-community/disko/latest -- \
     --mode disko \
     ./hosts/kea/disko.nix
   ```
   > [!TIP]
   > Disko will format `/dev/sda` and `/dev/sdb`, create LUKS2 containers (`crypted_ssd` and `crypted_storage`), establish all BTRFS subvolumes, and mount everything under `/mnt` and `/mnt/storage`.

2. Enable swapfile and confirm:
   ```sh
   swapon /mnt/swap/swapfile
   swapon -s
   ```
   > [!TIP]
   > Confirm swap attributes: `lsattr /mnt/swap` should show `---------------C------ /mnt/swap/swapfile` (No Copy-on-Write).
   > If not set up automatically, run:
   > ```sh
   > btrfs filesystem mkswapfile --size 24g --uuid clear /mnt/swap/swapfile
   > swapon /mnt/swap/swapfile
   > ```

3. Verify mountpoints:
   ```sh
   lsblk
   df -h
   ```
   Confirm `/mnt`, `/mnt/boot`, `/mnt/nix`, `/mnt/persistent`, `/mnt/storage`, and `/mnt/tmp` are mounted.

---

### 3. Update `hardware-configuration.nix`
1. Generate the base hardware configuration:
   ```sh
   nixos-generate-config --root /mnt
   ```

2. Retrieve the 5 UUIDs for `hardware-configuration.nix`:
   You can inspect all devices at once with:
   ```sh
   lsblk -f
   ```
   Or print the exact UUID for each variable directly:
   ```sh
   # 1. BOOT_ESP_UUID: EFI partition on SSD (/dev/sda1)
   blkid -s UUID -o value /dev/sda1

   # 2. SSD_LUKS_UUID: Encrypted LUKS partition on SSD (/dev/sda2)
   blkid -s UUID -o value /dev/sda2

   # 3. HDD_LUKS_UUID: Encrypted LUKS partition on HDD/Storage (/dev/sdb1)
   blkid -s UUID -o value /dev/sdb1

   # 4. SSD_BTRFS_UUID: Decrypted BTRFS filesystem on SSD (/dev/mapper/crypted_ssd)
   blkid -s UUID -o value /dev/mapper/crypted_ssd

   # 5. HDD_BTRFS_UUID: Decrypted BTRFS filesystem on HDD/Storage (/dev/mapper/crypted_storage)
   blkid -s UUID -o value /dev/mapper/crypted_storage
   ```

3. Update `hosts/kea/hardware-configuration.nix` by setting the 5 variables in the `let` block at the top:
   ```nix
   BOOT_ESP_UUID   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; # /dev/sda1 (FAT32 EFI partition)
   SSD_LUKS_UUID   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; # /dev/sda2 (LUKS partition on SSD)
   HDD_LUKS_UUID   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; # /dev/sdb1 (LUKS partition on Storage)
   SSD_BTRFS_UUID  = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; # /dev/mapper/crypted_ssd (Decrypted BTRFS filesystem on SSD)
   HDD_BTRFS_UUID  = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; # /dev/mapper/crypted_storage (Decrypted BTRFS filesystem on Storage)
   ```

4. Clean up the generated template files:
   ```sh
   rm -rf /mnt/etc/nixos/*
   ```

---

### 4. Perform Installation
Run the NixOS installer targeting `kea`:
```sh
nixos-install --root /mnt --no-root-password --flake .#kea --no-write-lock-file
```

> [!TIP]
> For verbose diagnostics if evaluation fails:
> `nixos-install --root /mnt --no-root-password --flake .#kea --no-write-lock-file --show-trace --verbose`

---

### 5. Post-Installation Setup
1. Create persistent user directories on both SSD and Storage:
   ```sh
   mkdir -p /mnt/persistent/home/dexter/Projects
   mkdir -p /mnt/persistent/etc
   mkdir -p /mnt/storage/home/dexter
   ```

2. Move SSH keys and configuration:
   ```sh
   mv /mnt/etc/ssh /mnt/persistent/etc/
   cp -r /root/nixos-config /mnt/persistent/home/dexter/Projects/
   ```

3. Ensure correct user ownership (UID 1000, GID 100):
   ```sh
   chown -R 1000:100 /mnt/persistent/home/dexter
   chown -R 1000:100 /mnt/storage/home/dexter
   ```

---

### 6. Reboot & Enroll TPM2
1. Reboot into the new system:
   ```sh
   reboot
   ```
2. Log in as `dexter` and refer to [SECUREBOOT.md](file:///home/factory/Projects/nixos-config/hosts/kea/SECUREBOOT.md) to enroll Secure Boot keys and TPM2 automatic unlocking for both `/dev/sda2` and `/dev/sdb1`.
