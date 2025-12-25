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
Terminal: Alacritty
```

## To do
These are in no particular order of priority

## Install
### Prerequsite
1. `sudo -i`
2. Clone the repo `git clone https://github.com/Factoryidiot/nixos-config.git`.
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
> !TIP
> Confirm swap, `lsattr /mnt/swap` should output:
>
> `---------------C------ /mnt/swap/swapfile`

> !TIP
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
3. Remove the contents of `rm /mnt/etc/nixos/*`.

### Perform installation
From `nixos-install` run:
```sh
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
- `mv /mnt/etc/ssh /mnt/persistent/etc`
- `mv ../nixos-config /mnt/persistent/home/{user}/Projects/Nixos/`

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

## Secrets Management (agenix)

This project uses `agenix` (specifically `ryan4yin/ragenix`) for declarative secret management. Secrets are stored in a separate, private GitHub repository and are accessed via a deploy key.

### Overview

1.  **Secrets Repository**: A dedicated private GitHub repository (e.g., `nixos-secrets`) stores all encrypted secrets.
2.  **Deploy Key**: An SSH deploy key grants read-only access to the secrets repository for your NixOS systems. The private part of this key is encrypted and managed by `agenix` within this `nixos-config` repository.
3.  **`agenix`**: Handles encryption/decryption of secrets based on specified public keys (recipients).

### Setup for a New Device or User

To enable secret access on a new NixOS device or for a new user, follow these steps:

#### 1. Generate Age Public Key (for new users)

If you are a new user, you need to generate an `age` public key. This key will be used to encrypt secrets so only you can decrypt them.

```bash
age-keygen -o ~/.config/sops/age/keys.txt # Generates a new key pair
cat ~/.config/sops/age/keys.txt | grep public # Display your public key
```

#### 2. Get Host Public Key (for new devices)

For a new NixOS device, you will need its host SSH public key, which `agenix` can use for decryption.

```bash
ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```
(Note: The path `/etc/ssh/ssh_host_ed25519_key.pub` might vary depending on your system.)

#### 3. Add New Recipient(s) to `nixos-config/secrets/secrets.nix`

Edit the `nixos-config/secrets/secrets.nix` file (in this repository) to include the public key(s) of the new device or user in the `publicKeys` list for *all* secrets they need to access.

**Example:**

```nix
# secrets/secrets.nix
{ ... }: {
  age.secrets.deploy-key = {
    file = ./deploy-key.age;
    publicKeys = [
      "age1...[existing-whio-test-public-key]..."
      "age1...[existing-rhys-public-key]..."
      "age1...[new-device-public-key]..."  # Add new device's age public key
      "age1...[new-user-public-key]..."    # Add new user's age public key
    ];
  };
  age.secrets.github_token = {
    file = ./github_token.age;
    publicKeys = [
      "age1...[existing-whio-test-public-key]..."
      "age1...[existing-rhys-public-key]..."
      "age1...[new-device-public-key]..."  # Add new device's age public key
      "age1...[new-user-public-key]..."    # Add new user's age public key
    ];
  };
}
```

#### 4. Re-encrypt Secrets

After adding new public keys, you *must* re-encrypt all affected `.age` files. This can be done using `agenix`.

**From within your NixOS VM or a system with `agenix` and access to *all* private keys for existing recipients:**

```bash
agenix -r secrets/deploy-key.age secrets/github_token.age
```
(Repeat for all `.age` files if you have more.)

Commit and push these re-encrypted secrets to this `nixos-config` repository.

#### 5. Clone the Secrets Repository

On the new device or for the new user, you need to clone the private `nixos-secrets` repository. This repository should contain a `secrets.nix` file (which defines additional secrets like your GitHub token) and their corresponding `.age` files.

```bash
git clone git@github.com:<your-username>/nixos-secrets.git /path/to/nixos-secrets
```
(Replace `/path/to/nixos-secrets` with the desired location, typically within your NixOS configuration directory if not already integrated as a flake input.)

#### 6. (Optional) Create New Encrypted Secrets

If you need to create a *new* secret:

1.  Add an entry for the new secret in `nixos-config/secrets/secrets.nix` with the relevant `publicKeys`.
2.  From within your NixOS VM (or a system with `agenix` and recipient private keys), create the encrypted file:
    ```bash
    agenix -e secrets/your-new-secret.age
    ```
    Paste the secret content, save, and exit.
3.  Re-encrypt all secrets (`agenix -r ...`) and commit/push changes to both repositories if applicable.

### Using Secrets in Your Configuration

Secrets defined in `nixos-config/secrets/secrets.nix` (like `deploy-key`) are available via `config.age.secrets.<secret-name>.path`.

Secrets defined in your separate `nixos-secrets` repository (like `github_token`) are available via `inputs.nixos-secrets.<secret-name>.path` or similar, depending on how you structure that repository.

```nix
# Example of using a secret in a NixOS module
{ config, inputs, ... }: {
  # For secrets managed directly in this repo
  environment.variables.DEPLOY_KEY_PATH = config.age.secrets.deploy-key.path;

  # For secrets from the 'nixos-secrets' flake input
  environment.variables.GITHUB_TOKEN_PATH = inputs.nixos-secrets.github_token.path;
}
```

---

## Filesystem Snapshots (Snapper)

This configuration uses `snapper` to automatically create and manage Btrfs filesystem snapshots. This provides a powerful data recovery mechanism that is complementary to NixOS generations. While NixOS generations protect your *system configuration*, snapper protects your *data* (e.g., your `/home` directory).

The configuration for `snapper` is named `root`.

### Listing Snapshots

To see a list of all available snapshots for the `root` configuration:

```bash
sudo snapper -c root list
```

This will output a table with the snapshot number, type, date, and description.

### Viewing Changes Between Snapshots

To see what files have been added, modified, or removed between two points in time, you can `diff` two snapshots.

```bash
# Show changes between snapshot 10 and snapshot 15
sudo snapper -c root diff 10..15
```

### Restoring a Single File

This is the most common and safest use case for `snapper`. If you accidentally delete a file, you can easily restore it from a recent snapshot.

Snapshots are accessible via a hidden `.snapshots` directory within the subvolume they belong to. For example, to restore a file in your home directory:

1.  List the snapshots (`sudo snapper -c root list`) to find a snapshot number (e.g., `#25`) from before the file was deleted.
2.  Navigate to the `.snapshots` directory and copy the file back.

    ```bash
    # Example: Restore 'my-deleted-file.txt' from your home directory
    sudo cp /home/.snapshots/25/snapshot/rhys/my-deleted-file.txt /home/rhys/
    ```
    *(Note: You will likely need `sudo` to access the `.snapshots` directory)*

### Performing a Full Rollback (Use with Caution)

A full rollback reverts the *entire subvolume* to a previous state. This is a destructive operation and should be used with care, as any changes made after the snapshot was taken will be lost. This is more powerful than restoring a single file but also riskier.

1.  List the snapshots to find the number of the snapshot you wish to roll back to.
2.  Execute the rollback command. This will create a new read-write snapshot of the target snapshot and set it as the new default subvolume.

    ```bash
    # Roll back the root subvolume to the state of snapshot 25
    sudo snapper -c root rollback 25
    ```
3.  **You must reboot** after performing a rollback for the changes to take effect.

---
## References
- https://github.com/ryan4yin/nix-config
- https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
- https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
- https://wiki.archlinux.org/title/Systemd-cryptenroll
- https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
