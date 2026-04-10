# tahi - NixOS Installation Guide

## Host
This section details the hardware configuration of the 'tahi' host, a ProLiant MicroServer Gen10.
```
Host: ProLiant MicroServer Gen10 (Rev B)
Kernel: Linux 6.8.12-4-pve (This will change after NixOS install)
CPU: AMD Opteron(tm) X3418 APU (4) @ 1.8 GHz
GPU 1: Advanced Micro Devices, Inc. [AMD/ATI] Wani [Radeon R5/R6/R7 Graphics]
Memory: 30 GiB
```

## Install
### Prerequisite
1.  `sudo -i`
2.  Clone the repo `git clone https://github.com/your-username/nixos-config.git
3.  Navigate to the cloned repository: `cd /nixos-config`.

### Prepare Disk and LUKS Keyfile

> [!CAUTION]
> **CRITICAL: VERIFY TARGET DISK**
> Your `disko.nix` is configured to partition `/dev/sda`. **Before proceeding, ensure that `/dev/sda` is indeed the correct 223.6G SSD for your NixOS installation and that you are not accidentally targeting another disk (e.g., `/dev/sdc`).**
>
> Run `lsblk -f` to verify disk names and sizes. Running `disko` on the wrong disk will **ERASE ALL DATA** on that disk.

1.  **Partition and Format with `disko`**:
    Execute the `disko` command, ensuring it targets `tahi` (which uses `/dev/sda`):
    ```sh
    nix --experimental-features "nix-command flakes" 
    run github:nix-community/disko/latest -- 
    --mode disko 
    ./disko.nix
    ```
    > !TIP
    > If there are errors in the disko process, you may need to update the script, push to git, `rm -rf .cache`, and rerun the line above.

2.  **Generate and Add LUKS Keyfiles**:
    a.  **For Primary LUKS Key (on /boot)**:
        *   Generate a secure random keyfile:
            ```sh
            dd if=/dev/urandom of=/mnt/boot/secret.key bs=512 count=1
            chmod 400 /mnt/boot/secret.key
            ```
        *   Add this keyfile to the LUKS volume (`/dev/disk/by-partlabel/disk-main-luks`):
            ```
            sudo cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-luks /mnt/boot/secret.key
            ```
            > IMPORTANT: You will be prompted for your main LUKS passphrase.
            > **CRITICAL:** After creating the key, verify its presence and permissions:
            > ```sh
            > ls -l /mnt/boot/secret.key
            > # Expected output example: -r-------- 1 root root 512 ... /mnt/boot/secret.key
            > ```
            > Ensure the file exists and has `0400` permissions (`-r--------`). If not, recreate it and set permissions.
    b.  **For Backup LUKS Key (on /dev/sdc)**:
        *   Generate a secure random keyfile on the `/dev/sdc` partition (mounted at `/mnt/luks-backup-key` by `disko`):
            ```sh
            dd if=/dev/urandom of=/mnt/luks-backup-key/tahi-luks-backup.key bs=512 count=1
            chmod 400 /mnt/luks-backup-key/tahi-luks-backup.key
            ```
        *   Add this keyfile to the LUKS volume (`/dev/disk/by-partlabel/disk-main-luks`):
            ```sh
            sudo cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-luks /mnt/luks-backup-key/tahi-luks-backup.key
            ```
            > IMPORTANT: You will be prompted for your main LUKS passphrase again.

3.  **Enable Swapfile (if configured in `disko.nix`):**
    *   `swapon /mnt/swap/swapfile` and confirm with `swapon -s`.
    > [!TIP]
    > Confirm swap, `lsattr /mnt/swap` should output:
    >
    > `---------------C------ /mnt/swap/swapfile`

### Update `hardware-configuration`
Generate a `hardware-configuration.nix` to get accurate UUIDs for your `tahi` hardware.
1.  Create `hardware-configuration.nix` for your current configuration:
    ```sh
    nixos-generate-config --root /mnt --dir /mnt/config/hosts/tahi
    ```
2.  **Identify LUKS Partition UUIDs:**
    *   Find the UUID of your main LUKS-encrypted partition (e.g., `/dev/sda2`). You can use `lsblk -f /dev/sda` or `blkid` after unlocking it.
    *   **CRITICAL:** Update the `UUID_OF_LUKS_PARTITION` placeholder in `/mnt/config/hosts/tahi/default.nix` with the actual UUID.
        *   Example: `boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/<YOUR_ACTUAL_LUKS_UUID>";`
    *   Find the UUID of the `/dev/sdc` partition (e.g., `/dev/sdc1`).
        *   Example: `lsblk -f /dev/sdc` or `blkid /dev/sdc1`
    *   **CRITICAL:** Update the `UUID_OF_SDC_PARTITION` placeholder in `/mnt/config/hosts/tahi/hardware-configuration.nix` with the actual UUID.
3.  Remove the contents of `/mnt/etc/nixos/*` created by `nixos-generate-config`, as we use our flake for configuration:
    ```sh
    rm /mnt/etc/nixos/*
    ```

### Perform Installation
From `/mnt/config` run:
```sh
nixos-install --root /mnt --no-root-password 
--flake .#tahi --no-write-lock-file
```
> [!TIP]
> To refresh the cache:
> nix: `--no-eval-cache`
> --flake: `--option eval-cache false`
>
> For troubleshooting and extra logging use:
> `--show-trace --verbose`

### Post Install
Move any essential files to their `/persistent` location, or update configurations.
-   `mv /mnt/etc/ssh /mnt/persistent/etc` (This is typically done by Home Manager for non-root users, but for root SSH keys it might be needed if not handled by `impermanence` or configuration.)
-   `mv hosts/{hostname}/hardware-configuration.nix /mnt/persistent/home/{user}/Documents/` (Adjust path as needed, or remove if not desired)
-   `mv /mnt/config /mnt/persistent/home/{user}/Projects/Nixos/` (Move the entire cloned repo to a persistent location)

### Reboot
`reboot`
