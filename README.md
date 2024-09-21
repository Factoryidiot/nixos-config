# nixos-config

## Hosts
whio

## To do
These are in no particular order of priority
- [ ] Retest hardware-configuration with /dev/mapper paths replacing UUIDs on the subvolumes
- [X] Implement Secureboot
- [ ] Install zsh, neovim, tmux, kitty, and fonts
- [ ] Install nvidia drivers
- [ ] Install hyprland
- [ ] Install Steam
- [ ] Install kvm-qemu and Looking Glass
- [ ] Implement Secrets

## Install
### Run disko
Boot up the nixos minimal installation disk and run as `sudo`
```
nix --experimental-features "nix-command flakes" \
run "github:nix-community/disko" -- \
--mode disko \
--flake "github:Factoryidiot/nixos-config#[host-name]"
```

`btrfs filesystem mkswapfile --size 24g --uuid clear /mnt/swap/swapfile`

`lsattr /mnt/swap`

`swapon /mnt/swap/swapfile`

### Prepare for install
1. Clone this repo to complete the installation:
   1. Enter a temporary Nix Shell and install git and vim `nix-shell -p git vim`.
   2. Clone this repo `git clone https://github.com/Factoryidiot/nixos-config.git`.
   3. `cd` into `nixos-config`.
2. Next we want to generate a `hardware-configuration.nix` to update the `UUID`s for the hardware-configuration.nix included in the repo we have just cloned.
```
 nixos-generate-config --root /mnt
```
3. Use vim to update the UUIDs found in `/mnt/etc/nixos/hardware-configuration.nix` into the hosts hardware-configuration e.g. `hosts/whio/hardware-configuration.nix`.
4. Remove the contents of `/mnt/etc/nixos/`.
5. From the Move `~/nixos-confg` to `/mnt/etc/nixos/`.
```
mv ../nixos-config /mnt/etc/nixos
```

### Perform installation
```
nixos-install --root /mnt --no-root-password \
--flake .#[host-name] --no-write-lock-file
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
- `mv /mnt/etc/machine-id /mnt/persistent/etc`
- `mv /mnt/etc/ssh /mnt/persistent/etc`

### Reboot
`reboot`

## Secureboot

1. Confirm the functional requirements are met

```
bootctl status
```
Output:
```
System:
     Firmware: UEFI 2.80 (American Megatrends 5.29)
Firmware Arch: x64
  Secure Boot: enabled (setup)
 TPM2 Support: yes
 Measured UKI: yes
 Boot into FW: supported

Current Boot Loader:
      Product: systemd-boot 256.4 

...

```
2. Create Secure Boot keys
```
sudo sbctl create-keys
```
Output:
```
[sudo] password for rhys:
Created Owner UUID 8ec4b2c3-dc7f-4362-b9a3-0cc17e5a34cd
Creating secure boot keys...✓
Secure boot keys created!
```
3. Configure NixOS and rebuild
4. Verify rebuilt systemd-boot
```
[to complete]
```
5. Enable Secure Boot in the bios

6. Enroll keys
```
sudo sbctl enroll-keys --microsoft

```
Output:
```
Enrolling keys to EFI variables...
With vendor keys from microsoft...✓
Enrolled keys to the EFI variables!
```
7. Confirm Secure Boot
```
System:
     Firmware: UEFI 2.80 (American Megatrends 5.29)
Firmware Arch: x64
  Secure Boot: enabled (user)
 TPM2 Support: yes
 Measured UKI: yes
 Boot into FW: supported

Current Boot Loader:
      Product: systemd-boot 256.4 

...

```

---
## References
- https://github.com/ryan4yin/nix-config
- https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
