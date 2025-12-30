{ config
, lib
, pkgs
, modulesPath
, ...
}: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;

  boot.initrd.availableKernelModules = [ "virtio_blk" "virtio_gpu" "virtio_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.systemd.enable = true;

  boot.extraModulePackages = [ ];

  boot.kernelModules = [ "virtio_pci" "virtio-input" "virtio_gpu" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ ];

  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];

  boot.tmp.cleanOnBoot = true; # clear /tmp on boot to get a stateless /tmp directory

  boot.initrd = {
    luks.devices."crypted" = lib.mkDefault {
      device = "/dev/disk/by-uuid/ea4c4512-4b8a-4231-8092-f51f076446b0";
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  fileSystems."/boot" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/9AB3-3B8F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/btr_pool" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/02656142-8d5c-4599-9b97-fe51848f8dcf";
      fsType = "btrfs";
      options = [ "subvolid=5" ];
    };

  fileSystems."/" = lib.mkDefault
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "relatime" "mode=755" ];
    };

  fileSystems."/gnu" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/02656142-8d5c-4599-9b97-fe51848f8dcf";
      fsType = "btrfs";
      options = [ "subvol=@guix" "noatime" "compress-force=zstd:1" ];
    };

  fileSystems."/nix" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/02656142-8d5c-4599-9b97-fe51848f8dcf";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress-force=zstd:1" ];
    };

  fileSystems."/persistent" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/02656142-8d5c-4599-9b97-fe51848f8dcf";
      fsType = "btrfs";
      options = [ "subvol=@persistent" "compress-force=zstd:1" ];
      neededForBoot = true;
    };

  fileSystems."/snapshots" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/02656142-8d5c-4599-9b97-fe51848f8dcf";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" "compress-force=zstd:1" ];
    };

  fileSystems."/swap" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/02656142-8d5c-4599-9b97-fe51848f8dcf";
      fsType = "btrfs";
      options = [ "subvol=@swap" "ro" ];
    };

  fileSystems."/swap/swapfile" =
    {
      depends = [ "/swap" ];
      device = "/swap/swapfile";
      fsType = "none";
      options = [ "bind" "rw" ];
    };

  fileSystems."/tmp" = lib.mkDefault
    {
      device = "/dev/disk/by-uuid/02656142-8d5c-4599-9b97-fe51848f8dcf";
      fsType = "btrfs";
      options = [ "subvol=@tmp" "compress-force=zstd:1" ];
    };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

}
