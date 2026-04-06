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
NAME                           SIZE ROTA MODEL                TRAN
loop0                            8G    0                      
loop1                           20G    0                      
sda                          223.6G    0 ADATA SU630          sata
sdb                            5.5T    1 WDC WD60EFAX-68SHWN0 sata
sdc                            5.5T    1 WDC WD60EFAX-68SHWN0 sata
sdd                            5.5T    1 WDC WD60EFAX-68SHWN0 sata
sde                            5.5T    1 WDC WD60EFAX-68SHWN0 sata
sdf                           58.6G    1 OnlyDisk             usb
```
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
