## Host
```
Host: ASUS TUF Gaming A15 FA507UI_FA507UI (1.0)
Kernel: Linux 6.6.49
Display (NE156FHM-NX6): 1920x1080 @ 144 Hz in 15″ [Built-in]
CPU: AMD Ryzen 9 8945H w/ Radeon 780M Graphics (16) @ 6.23 GHz
GPU 1: NVIDIA GeForce RTX 4070 Max-Q / Mobile [Discrete]
GPU 2: AMD Phoenix3 [Integrated]
Memory: 16 GiB
```
## Environment
```
OS: NixOS 24.11.20240906.574d1ea (Vicuna) x86_64
Terminal: kitty
Shell: zsh
WM: Hyprland (Wayland)
```
## Disk
```
❯ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
zram0       253:0    0   7.5G  0 disk  [SWAP]
nvme0n1     259:0    0 953.9G  0 disk
├─nvme0n1p1 259:1    0   499M  0 part  /boot
└─nvme0n1p2 259:2    0 953.4G  0 part
  └─crypted 254:0    0 953.4G  0 crypt /swap/swapfile
                                       /tmp
                                       /swap
                                       /snapshots
                                       /home/rhys/tmp
                                       /home/rhys/Videos
                                       /home/rhys/Projects
                                       /home/rhys/Pictures
                                       /home/rhys/Music
                                       /home/rhys/Downloads
                                       /home/rhys/Documents
                                       /home/rhys/.steam
                                       /home/rhys/.ssh
                                       /home/rhys/.pki
                                       /home/rhys/.npm
                                       /home/rhys/.local/state
                                       /home/rhys/.local/share
                                       /home/rhys/.gnupg
                                       /home/rhys/.config/pulse
                                       /home/rhys/.config/obsidian
                                       /home/rhys/.config/google-chrome
                                       /gnu
                                       /home/rhys/.config/Bitwarden
                                       /etc/ssh
                                       /etc/secureboot
                                       /etc/NetworkManager/system-connections
                                       /etc/nix/inputs
                                       /btr_pool
                                       /etc/machine-id
                                       /home/rhys/.zsh_history
                                       /nix/store
                                       /var/log
                                       /var/lib
                                       /nix
                                       /persistent
```
```
❯ df -Th
Filesystem          Type      Size  Used Avail Use% Mounted on
tmpfs               tmpfs     7.5G  226M  7.3G   3% /
/dev/mapper/crypted btrfs     954G  161G  791G  17% /persistent
/dev/mapper/crypted btrfs     954G  161G  791G  17% /nix
tmpfs               tmpfs     3.8G  6.2M  3.8G   1% /run
devtmpfs            devtmpfs  764M     0  764M   0% /dev
tmpfs               tmpfs     7.5G  212M  7.3G   3% /dev/shm
efivarfs            efivarfs  128K   41K   83K  34% /sys/firmware/efi/efivars
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-sysctl.service
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-tmpfiles-setup-dev-early.service
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-tmpfiles-setup-dev.service
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-vconsole-setup.service
/dev/mapper/crypted btrfs     954G  161G  791G  17% /btr_pool
/dev/mapper/crypted btrfs     954G  161G  791G  17% /gnu
/dev/nvme0n1p1      vfat      499M   96M  404M  20% /boot
/dev/mapper/crypted btrfs     954G  161G  791G  17% /snapshots
/dev/mapper/crypted btrfs     954G  161G  791G  17% /swap
/dev/mapper/crypted btrfs     954G  161G  791G  17% /tmp
tmpfs               tmpfs     7.5G  1.3M  7.5G   1% /run/wrappers
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-tmpfiles-setup.service
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
tmpfs               tmpfs     1.5G  2.8M  1.5G   1% /run/user/1000
```
