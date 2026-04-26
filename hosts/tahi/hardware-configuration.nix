# /hosts/tahi/hardware-configuration.nix
{ config
, lib
, pkgs
, modulesPath
, ...
}:
let
  btrfsOptions = [ "noatime" "compress=zstd:1" "ssd" "discard=async" ];
in
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "btrfs" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [ "amd_pstate=active" "amd.iommu=on" "rootWait=10" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.tmp.cleanOnBoot = true; # clear /tmp on boot to get a stateless /tmp directory
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];

  fileSystems."/boot" = lib.mkDefault
    { device = "/dev/disk/by-uuid/472A-8EC9";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/btr_pool" = lib.mkDefault
    { device = "/dev/disk/by-uuid/b0e26576-945c-4f26-97c8-d8a0ac70283c";
      fsType = "btrfs";
      options = [ "subvolid=5" ];
    };

  fileSystems."/" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "relatime" "mode=755" ];
      neededForBoot = true;
    };

  fileSystems."/gnu" = lib.mkDefault
    { device = "/dev/disk/by-uuid/b0e26576-945c-4f26-97c8-d8a0ac70283c";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@guix" ];
    };

  fileSystems."/nix" = lib.mkDefault
    { device = "/dev/disk/by-uuid/b0e26576-945c-4f26-97c8-d8a0ac70283c";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@nix" ];
      neededForBoot = true;
    };

  fileSystems."/persistent" = lib.mkDefault
    { device = "/dev/disk/by-uuid/b0e26576-945c-4f26-97c8-d8a0ac70283c";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@persistent" ];
      neededForBoot = true;
    };

  fileSystems."/snapshots" = lib.mkDefault
    { device = "/dev/disk/by-uuid/b0e26576-945c-4f26-97c8-d8a0ac70283c";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@snapshots" ];
    };

  fileSystems."/swap" = lib.mkDefault
    { device = "/dev/disk/by-uuid/b0e26576-945c-4f26-97c8-d8a0ac70283c";
      fsType = "btrfs";
      options = [ "subvol=swap" "nodatacow" "noatime" ];
    };

  fileSystems."/swap/swapfile" =
    {
      device = "/swap/swapfile";
      depends = [ "/swap" ];
      fsType = "none";
      options = [ "bind" "rw" ];
    };

  fileSystems."/tmp" = lib.mkDefault
    { device = "/dev/disk/by-uuid/b0e26576-945c-4f26-97c8-d8a0ac70283c";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@tmp" ];
    };

  #swapDevices = [
  #  { device = "/swap/swapfile"; }
  #];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

}

