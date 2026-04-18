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

### Prepare Disk

> [!CAUTION]
> **CRITICAL: VERIFY TARGET DISK**
> Your `disko.nix` will be configured to partition your main disk. **Before proceeding, ensure that you have correctly identified the target disk (e.g., `/dev/sdb` or `/dev/sdd`) for your NixOS installation and that you are not accidentally targeting another disk.**
>
> Run `lsblk -f` to verify disk names and sizes. Running `disko` on the wrong disk will **ERASE ALL DATA** on that disk.

1. **Partition and Format with `disko`**:
    First, ensure `hosts/tahi/disko.nix` is updated with the correct main disk device path.
    Then, execute the `disko` command, ensuring it targets `tahi` (which uses your specified main disk):
    ```sh
    nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko/latest -- \
    --mode disko \
    ./disko.nix
    ```
    > !TIP
    > If there are errors in the disko process, you may need to update the script, push to git, `rm -rf .cache`, and rerun the line above.

2.  **Enable Swapfile (if configured in `disko.nix`):**
    *   `swapon /mnt/swap/swapfile` and confirm with `swapon -s`.
    > [!TIP]
    > Confirm swap, `lsattr /mnt/swap` should output:
    >
    > `---------------C------ /mnt/swap/swapfile`

### Update `hardware-configuration`
Generate a `hardware-configuration.nix` to get accurate UUIDs for your `tahi` hardware.
1.  Create `hardware-configuration.nix` for your current configuration:
    ```sh
    nixos-generate-config --root /mnt
    ```
2.  Remove the contents of `/mnt/etc/nixos/*` created by `nixos-generate-config`, as we use our flake for configuration:
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
