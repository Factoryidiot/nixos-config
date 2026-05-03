## Secureboot

To Implement Secure Book with LUKS and TPM2, to avoid having to manually enter the pass-phrase each time we reboot.

Prerequsite:
- tpm2-tss
- boot.initrd.systemd.enable = true;

### Configure and enable Secure Boot
1. Confirm the functional requirements are met
```sh
bootctl status
```
Output:
```sh
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
```sh
sudo nix run nixpkgs#sbctl create-keys
```
Output:
```sh
Created Owner UUID 8ec4b2c3-dc7f-4362-b9a3-0cc17e5a34cd
Creating secure boot keys...✓
Secure boot keys created!
```
3. Configure NixOS
4. Rebuild switch, and reboot 
5. Verify that the set up is ready for Secure Boot
```sh
sudo nix run nixpkgs#sbctl verify
```
Output
```sh
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
```sh
sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
```
Output:
```sh
Enrolling keys to EFI variables...
With vendor keys from microsoft...✓
Enrolled keys to the EFI variables!
```
7. Reboot
8. Confirm Secure Boot
```sh
bootctl status
```
Output:
```sh
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
```sh
sudo systemd-cryptenroll --tpm2-device auto --tpm2-pcrs "0+2+7+12" --wipe-slot tpm2 /dev/nvme0n1p2
```
2. Recovery Key Enrollment
This will create another key partition called recovery and a recovery key, store this somewhere safe.
```sh
sudo systemd-cryptenroll --recovery-key /dev/nvme0n1p2
```
