## Host
This section details the hardware configuration of the 'tahi' host, a ProLiant MicroServer Gen10.
```
Host: ProLiant MicroServer Gen10 (Rev B)
Kernel: Linux 6.8.12-4-pve
CPU: AMD Opteron(tm) X3418 APU (4) @ 1.8 GHz
GPU 1: Advanced Micro Devices, Inc. [AMD/ATI] Wani [Radeon R5/R6/R7 Graphics]
Memory: 30 GiB
```
## Environment
```
OS: Debian GNU/Linux 12 (bookworm) x86_64
Shell: bash
```
## Disk
```
❯ lsblk
NAME                         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0                          7:0    0     8G  0 loop 
loop1                          7:1    0    20G  0 loop 
sda                            8:0    0 223.6G  0 disk 
├─sda1                         8:1    0  1007K  0 part 
├─sda2                         8:2    0     1G  0 part /boot/efi
└─sda3                         8:3    0 222.6G  0 part 
  ├─pve-swap                 252:0    0     8G  0 lvm  [SWAP]
  ├─pve-root                 252:1    0  65.6G  0 lvm  /
  ├─pve-data_tmeta           252:2    0   1.3G  0 lvm  
  │ └─pve-data-tpool         252:4    0 130.3G  0 lvm  
  │   ├─pve-data             252:5    0 130.3G  1 lvm  
  │   ├─pve-vm--100--disk--0 252:6    0    32G  0 lvm  
  │   └─pve-vm--104--disk--0 252:7    0    32G  0 lvm  
  └─pve-data_tdata           252:3    0 130.3G  0 lvm  
    └─pve-data-tpool         252:4    0 130.3G  0 lvm  
      ├─pve-data             252:5    0 130.3G  1 lvm  
      ├─pve-vm--100--disk--0 252:6    0    32G  0 lvm  
      └─pve-vm--104--disk--0 252:7    0    32G  0 lvm  
sdb                            8:16   0   5.5T  0 disk 
└─sdb1                         8:17   0   5.5T  0 part 
sdc                            8:32   0   5.5T  0 disk 
└─sdc1                         8:33   0   5.5T  0 part 
sdd                            8:48   0   5.5T  0 disk 
└─sdd1                         8:49   0   5.5T  0 part 
sde                            8:64   0   5.5T  0 disk 
└─sde1                         8:65   0   5.5T  0 part 
sdf                            8:80   1  58.6G  0 disk 
└─sdf1                         8:81   1  58.6G  0 part 
sdg                            8:96   0   500G  0 disk 

❯ df -Th 
Filesystem                            Type      Size  Used Avail Use% Mounted on
udev                                  devtmpfs   16G     0   16G   0% /dev
tmpfs                                 tmpfs     3.1G  2.8M  3.1G   1% /run
/dev/mapper/pve-root                  ext4       65G   61G  135M 100% /
tmpfs                                 tmpfs      16G   46M   16G   1% /dev/shm
tmpfs                                 tmpfs     5.0M     0  5.0M   0% /run/lock
efivarfs                              efivarfs  128K   27K   97K  22% /sys/firmware/efi/efivars
/dev/sda2                             vfat     1022M   12M 1011M   2% /boot/efi
/dev/fuse                             fuse      128M   20K  128M   1% /etc/pve
172.16.1.31:/mnt/tahinas/Game_Servers nfs4       11T  1.9G   11T   1% /mnt/pve/tahinas_game_servers
172.16.1.31:/mnt/tahinas/Backups      nfs4       11T     0   11T   0% /mnt/pve/truenas_backups
172.16.1.31:/mnt/tahinas/ISOs         nfs4       11T  2.5G   11T   1% /mnt/pve/truenas_isos
tmpfs                                 tmpfs     3.1G     0  3.1G   0% /run/user/0
