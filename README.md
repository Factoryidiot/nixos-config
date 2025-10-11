# nixos-config

## Hosts
whio
```
Host: ASUS TUF Gaming A15 FA507UI_FA507UI (1.0)
CPU: AMD Ryzen 9 8945H w/ Radeon 780M Graphics (16) @ 6.23 GHz
GPU 1: NVIDIA GeForce RTX 4070 Max-Q / Mobile [Discrete]
GPU 2: AMD Phoenix3 [Integrated]
Display (NE156FHM-NX6): 1920x1080 @ 144 Hz in 15″ [Built-in]
Memory: 16 GiB

OS: NixOS 24.11.20240906.574d1ea (Vicuna) x86_64
Kernel: Linux 6.6.49
Shell: zsh 5.9
WM: Hyprland (Wayland)
Terminal: kitty 0.36.1
```

## To do
These are in no particular order of priority
- [X] Retest hardware-configuration with /dev/mapper paths replacing UUIDs on the subvolumes
- [X] Implement Secureboot
- [ ] Implement Secrets
- [/] Install zsh, neovim, tmux, kitty, and fonts
- [/] Install nvidia drivers
- [/] Install hyprland
- [/] Install Steam
- [/] Install kvm-qemu and Looking Glass
- [ ] Tidy up and restructure

## Install
### Run disko
Boot up the nixos minimal installation disk and run as `sudo -i`

```
nix --experimental-features "nix-command flakes" \
run "github:nix-community/disko" -- \
--mode disko \
--flake "github:Factoryidiot/nixos-config#[host-name]"
```

Confirm swap, `lsattr` should output:

`---------------C------ /mnt/swap/swapfile`

`lsattr /mnt/swap`

if not, run:

`btrfs filesystem mkswapfile --size 24g --uuid clear /mnt/swap/swapfile`

Run `swapon /mnt/swap/swapfile` and confim `swapon -s`

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
    `mv /mnt/etc/machine-id /mnt/persistent/etc`
    `mv /mnt/etc/ssh /mnt/persistent/etc`
    `mv ../nixos-config /mnt/persistent/home/{user}/`

### Reboot
`reboot`

---

## Secureboot

To Implement Secure Book with LUKS and TPM2, to avoid having to manually enter the pass-phrase each time we reboot.

Prerequsite:
- tpm2-tss
- boot.initrd.systemd.enable = true;

### Configure and enable Secure Boot
1. Confirm the functional requirements are met

```
bootctl status
```
Output:
```
System:
     Firmware: UEFI 2.80 (American Megatrends 5.29)
Firmware Arch: x64
  Secure Boot: disabled (setup)
 TPM2 Support: yes
 Measured UKI: yes
 Boot into FW: supported

Current Boot Loader:
      Product: systemd-boot 256.4 
...

```
2. Create Secure Boot keys
```
sudo nix run nixpkgs#sbctl create-keys
```
Output:
```
Created Owner UUID 8ec4b2c3-dc7f-4362-b9a3-0cc17e5a34cd
Creating secure boot keys...✓
Secure boot keys created!
```
3. Configure NixOS
4. Rebuild switch, and reboot 
5. Verify that the set up is ready for Secure Boot
```
sudo nix run nixpkgs#sbctl verify
```
Output
```
Verifying file database and EFI images in /boot...
✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
✓ /boot/EFI/Linux/nixos-generation-100-kr26liccc5utoga5un626z7whlcja5iisqjgwihjecl4bi7ycwsq.efi is signed
✓ /boot/EFI/Linux/nixos-generation-101-u2aurkraw74u7cd42zqy6abhki3vc6gzaqe2532hp2ulzukxzqca.efi is signed
✓ /boot/EFI/Linux/nixos-generation-102-hktgabnyiy7xawxxxvkvwg46nsjd547hkjdy7yhw5t463tkhjama.efi is signed
✓ /boot/EFI/Linux/nixos-generation-98-nlo7qbolb6jhjpgo76v7ltyrg3paysjsk5za5cy3cgd5mh5gp3ia.efi is signed
✓ /boot/EFI/Linux/nixos-generation-99-e35bimscug7ak2bcbnmvuf46gsxagcp23aouv55ou63qgxc3ljqa.efi is signed
✗ /boot/EFI/nixos/kernel-6.6.49-k5dr55klogwvuwfxubqzcoinicnx5as73xwvwy2p6oweso7riv3a.efi is not signed
✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
```
5. Reboot and enable Secure Boot in the bios, if it has not been enabled already
6. Enroll boot keys
```
sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
```
Output:
```
Enrolling keys to EFI variables...
With vendor keys from microsoft...✓
Enrolled keys to the EFI variables!
```
7. Reboot
8. Confirm Secure Boot
```
bootctl status
```
Output:
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
### TPM LUKS unlock
1. Crypt Enroll
```
sudo systemd-cryptenroll --tpm2-device auto --tpm2-pcrs "0+2+7+12" --wipe-slot tpm2 /dev/nvme0n1p2

```
2. Recovery Key Enrollment
This will create another key partition called recovery and a recovery key, store this somewhere safe.
```
sudo systemd-cryptenroll --recovery-key /dev/nvme0n1p2

```

---
## References
- https://github.com/ryan4yin/nix-config
- https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
- https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
- https://wiki.archlinux.org/title/Systemd-cryptenroll
- https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
