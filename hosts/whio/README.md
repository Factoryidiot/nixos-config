## Host
This section details the primary hardware specifications of the 'whio' host, an ASUS TUF Gaming A15 laptop. It summarizes key components such as the CPU, GPU (both discrete and integrated), system memory, and display characteristics, highlighting its powerful configuration for gaming and demanding tasks.
```
 PC: ASUS TUF Gaming A15 FA507UI_FA507UI (1.0)
├: AMD Ryzen 9 8945H (16) @ 5.26 GHz
├: NVIDIA GeForce RTX 4070 Max-Q / Mobile [Discrete]
├: AMD Radeon 780M Graphics [Integrated]
├󱄄: 2560x1440 in 27", 100 Hz [External]
├󱄄: 1920x1080 in 15", 144 Hz [Built-in]
├󰋊: 1.65 GiB / 15.32 GiB (11%) - tmpfs
├󰋊: 51.21 GiB / 953.36 GiB (5%) - btrfs
├: 14.75 GiB / 30.63 GiB (48%)
└󰓡 : 0 B / 39.32 GiB (0%)
```
## Environment
This section outlines the software environment of the 'whio' host, detailing the operating system (OS) version, kernel, terminal emulator, default shell, and window manager (WM).
```
 OS: NixOS 25.11 (Xantusia) x86_64
├: Linux 6.18.9-zen1
├: Hyprland 0.53.0 (Wayland)
├: node
├󰏖: 2104 (nix-system), 1405 (nix-user), 10 (flatpak)
└󰸌:  ●●●●●●●●
```
## Disk
This section provides a detailed overview of the disk configuration and filesystem usage on the 'whio' host. While `fastfetch` provides a summary of disk usage, `lsblk` offers a raw look at disk devices and partitions, and `df -Th` provides detailed information on mounted filesystems, their types, sizes, and usage.
```
❯ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
zram0       253:0    0  15.3G  0 disk  [SWAP]
nvme0n1     259:0    0 953.9G  0 disk
├─nvme0n1p1 259:1    0   499M  0 part  /boot
└─nvme0n1p2 259:2    0 953.4G  0 part
  └─crypted 254:0    0 953.4G  0 crypt /persistent/var/lib/docker/btrfs
                                       /var/lib/docker/btrfs
                                       /swap/swapfile
                                       /tmp
                                       /swap
                                       /snapshots
                                       /gnu
                                       /btr_pool
                                       /var/lib/sbctl
                                       /var/lib/systemd/timers
                                       /var/lib/iwd
                                       /var/lib/flatpak
                                       /var/lib/docker
                                       /var/lib/bluetooth
                                       /var/lib/agenix
                                       /home/factory/tmp
                                       /home/factory/Videos
                                       /home/factory/VMs
                                       /home/factory/Projects
                                       /home/factory/Pictures
                                       /home/factory/Music
                                       /home/factory/Downloads
                                       /home/factory/Documents
                                       /home/factory/.var/app
                                       /home/factory/.steam
                                       /home/factory/.ssh
                                       /home/factory/.pki
                                       /home/factory/.npm
                                       /home/factory/.mozilla
                                       /home/factory/.local/state
                                       /home/factory/.local/share/flatpak
                                       /home/factory/.local/share/docker
                                       /home/factory/.local/share/Steam
                                       /home/factory/.gnupg
                                       /home/factory/.dotfiles
                                       /home/factory/.config/pulse
                                       /home/factory/.config/BraveSoftware
                                       /home/factory/.config/Bitwarden
                                       /home/factory/.aws
                                       /etc/nix/inputs
                                       /etc/agenix
                                       /etc/asusd
                                       /home/factory/.config/zsh/.zsh_history
                                       /etc/ssh/ssh_host_rsa_key.pub
                                       /etc/ssh/ssh_host_rsa_key
                                       /etc/ssh/ssh_host_ed25519_key.pub
                                       /etc/ssh/ssh_host_ed25519_key
                                       /etc/machine-id
                                       /nix/store
                                       /var/log
                                       /var/lib/nixos
                                       /nix
                                       /persistent
```
```
❯ df -Th
Filesystem          Type      Size  Used Avail Use% Mounted on
tmpfs               tmpfs      16G  1.8G   14G  12% /
tmpfs               tmpfs     7.7G  7.2M  7.7G   1% /run
/dev/mapper/crypted btrfs     954G   52G  901G   6% /persistent
/dev/mapper/crypted btrfs     954G   52G  901G   6% /nix
devtmpfs            devtmpfs  1.6G     0  1.6G   0% /dev
tmpfs               tmpfs      16G   36M   16G   1% /dev/shm
efivarfs            efivarfs  128K   50K   74K  41% /sys/firmware/efi/efivars
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
/dev/mapper/crypted btrfs     954G   52G  901G   6% /btr_pool
/dev/mapper/crypted btrfs     954G   52G  901G   6% /gnu
/dev/mapper/crypted btrfs     954G   52G  901G   6% /snapshots
/dev/mapper/crypted btrfs     954G   52G  901G   6% /swap
/dev/mapper/crypted btrfs     954G   52G  901G   6% /tmp
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
tmpfs               tmpfs      16G  1.4M   16G   1% /run/wrappers
/dev/nvme0n1p1      vfat      499M   40M  460M   8% /boot
tmpfs               tmpfs     1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
tmpfs               tmpfs     3.1G  6.3M  3.1G   1% /run/user/1000


