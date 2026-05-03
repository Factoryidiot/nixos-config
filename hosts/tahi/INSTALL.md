# tahi - NixOS Installation Guide

## Host
tahi
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
2.  Clone the repo `git clone https://github.com/Factoryidiot/nixos-config.git`
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
1. Create `hardware-configuration.nix` for your current configuration:
```sh
nixos-generate-config --root /mnt
```
2. Remove the contents of `/mnt/etc/nixos/*` created by `nixos-generate-config`, as we use our flake for configuration:
```sh
 rm /mnt/etc/nixos/*
```
### Perform Installation
From `/mnt/config` run:
```sh
git add .
nixos-install --root /mnt --no-root-password --flake .#tahi --no-write-lock-file
```
> [!TIP]
> To refresh the cache:
> nix: `--no-eval-cache`
> --flake: `--option eval-cache false`
>
> For troubleshooting and extra logging use:
> `--show-trace --verbose`

### Post install
Move any essential files to their `/persistent` location
- `mv /mnt/etc/ssh /mnt/persistent/etc`
- `cp hosts/tahi/hardware-configuration.nix /mnt/persistent/home/factory/Projects/`
- `mv ../nixos-config /mnt/persistent/home/factory/Projects/`

> [!TIP]
> **Configure Local PII**
> After installation, remember to configure your local PII (Git user name and email) by following the instructions in the "Local PII Management" section of this README.

#### SSH Access (Post-Reboot Preparation)

Before rebooting, ensure you set up SSH access for the `factory` user, as it's configured for persistence and password authentication is disabled.

1. **Retrieve your SSH Public Key:**
On your client machine (the one you'll be SSHing *from*), get your public SSH key. It's usually in `~/.ssh/id_rsa.pub` (or `id_ed25519.pub`). Copy its content.
```bash
cat ~/.ssh/id_rsa.pub
# Copy the entire output string (e.g., ssh-rsa AAAA...)
```
1. **Add your Public Key to the `factory` User's `authorized_keys` on the Installed `tahi` System:**
While you are still in the installation environment (before rebooting), perform these commands. We assume `/mnt` is the mount point for your newly installed system's root.
2. Add your public key to the authorized_keys file
```sh
echo "PASTE_YOUR_PUBLIC_SSH_KEY_HERE" >> /mnt/persistent/home/factory/.ssh/authorized_keys
```
3. Set correct permissions for the authorized_keys file
```sh
chmod 600 /mnt/persistent/home/factory/.ssh/authorized_keys
```
4. **SSH into `tahi` after Reboot:**
Once `tahi` has rebooted and acquired a network address, you should be able to SSH into it as the `factory` user:
```sh
ssh factory@<tahi_ip_address_or_hostname>
```
### Reboot
`reboot`
