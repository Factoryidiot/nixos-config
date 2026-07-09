# whio - NixOS Installation Guide
[[SECUREBOOT]]
## Hosts
whio
```
Host: ASUS TUF Gaming A15 FA507UI_FA507UI (1.0)
CPU: AMD Ryzen 9 8945H w/ Radeon 780M Graphics (16) @ 6.23 GHz
GPU 1: NVIDIA GeForce RTX 4070 Max-Q / Mobile [Discrete]
GPU 2: AMD Phoenix3 [Integrated]
Display (NE156FHM-NX6): 1920x1080 @ 144 Hz in 15″ [Built-in]
Memory: 32 GiB

OS:
Kernel: Linux
Shell: zsh 5.9
WM: Hyprland (Wayland)
Terminal: Alacritty
```
## To do
These are in no particular order of priority

## Install
### Prerequsite
1. `sudo -i`
2. Clone the repo `git clone https://github.com/your-username/nixos-config.git`.
### Prepare Disk
1. Navigate to the desired hosts disko configuration and execute: 
```sh
nix --experimental-features "nix-command flakes" \
run github:nix-community/disko/latest -- \
--mode disko \
./disko.nix
```
> !TIP
> if there are errors in the disko process, we can update the script push to git `rm -rf .cache` and rerun the line above.
2. Enable swapfile `swapon /mnt/swap/swapfile` and confim `swapon -s` if required
> [!TIP]
> Confirm swap, `lsattr /mnt/swap` should output:
>
> `---------------C------ /mnt/swap/swapfile`

> [!TIP]
> If a swap partition is not set up we can do this manually
> `btrfs filesystem mkswapfile --size 24g --uuid clear /mnt/swap/swapfile`
> Then run swapon see step 2.

### Update `hardware-configuration`
Generate a `hardware-configuration.nix` to update the `UUID`s for the hardware-configuration.nix included in the repo we have just cloned.
1. Create `hardware-configuration.nix` for your current configuration:
```sh
 nixos-generate-config --root /mnt
```
2. Use editor to update the UUIDs found in `/mnt/etc/nixos/hardware-configuration.nix` into the hosts hardware-configuration e.g. `hosts/whio/hardware-configuration.nix`.
> [!TIP]
> ls -la /dev/disk/by-uuid/ > uuids
3. Remove the contents of `rm /mnt/etc/nixos/*`.
### Perform installation
From `/nixos-config` run:
```sh
nixos-install --root /mnt --no-root-password --flake .#[host-name] --no-write-lock-file
```
> [!TIP]
> To refresh the cache:
> nix: `--no-eval-cache`
> --flake: `--option eval-cache false`

> [!TIP]
> For troubleshooting and extra logging use:
> --show-trace --verbose
### Post install
Move any essential files to their `/persistent` location
- `mv /mnt/etc/ssh /mnt/persistent/etc`
- `mv hosts/whio/hardware-configuration.nix /mnt/persistent/home/factory/Projects/`
- `mv ../nixos-config /mnt/persistent/home/factory/Projects/`

> [!TIP]
> **Configure Local PII**
> After installation, remember to configure your local PII (Git user name and email) by following the instructions in the "Local PII Management" section of this README.

### Reboot
`reboot`
