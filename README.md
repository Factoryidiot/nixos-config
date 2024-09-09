# nixos-config

## To do
These are in no particular order of priority
- [ ] Retest hardware-configuration with /dev/mapper paths replacing UUIDs on the subvolumes
- [ ] Install zsh, neovim, tmux and kitty
- [ ] Install nvidia drivers
- [ ] Install hyprland
- [ ] Install Steam
- [ ] Install kvm-qemu and Looking Glass

## Install
### Run disko
Boot up the nixos minimal installation disk and run as `sudo`
```
nix --experimental-features "nix-command flakes" \
run "github:nix-community/disko" -- \
--mode disko \
--flake "github:Factoryidiot/nixos-config#[host-name]"
```
### Prepare for install
1. Clone this repo to complete the installation:
   a. Enter a temporary Nix Shell and install git and vim `nix-shell -p git vim`.
   b. Clone this repo `git clone https://github.com/Factoryidiot/nixos-config.git`.
   c. `cd` into `nixos-config`.

2. Next we want to generate a `hardware-configuration.nix` to update the `UUID`s for the hardware-configuration.nix included in the repo we have just cloned.
```
 nixos-generate-config --root /mnt
```
4. Use vim to update the UUIDs found in `/mnt/etc/nixos/hardware-configuration.nix` into the hosts hardware-configuration e.g. `hosts/whio/hardware-configuration.nix`

### Perform installation
```
nixos-install --root /mnt --no-root-password --show-trace --verbose \
--flake "github:Factoryidiot/nix-config#[host-name]" --no-write-lock-file
```



---

## Install home
```
nix run home-manager/master --accept-flake-config -- switch \
    --flake "github:Factoryidiot/nix-config#[user-name]" --no-write-lock-file
```
