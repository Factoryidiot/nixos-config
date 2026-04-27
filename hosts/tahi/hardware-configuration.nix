# /hosts/tahi/hardware-configuration.nix
{ config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  btrfsOptions = [ "noatime" "compress=zstd:1" "ssd" "discard=async" ];
  uuid = "7f124d78-940d-4dfc-bd23-ba8dadeb5d63";
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

  fileSystems."/" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "relatime" "mode=755" "size=8G" ];
      neededForBoot = true;
    };

  fileSystems."/nix" = lib.mkDefault
    { device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@nix" ];
      neededForBoot = true;
    };

  fileSystems."/persistent" = lib.mkDefault
    { device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@persistent" ];
      neededForBoot = true;
    };

  fileSystems."/boot" = lib.mkDefault
    { device = "/dev/disk/by-uuid/5398-3214";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/gnu" = lib.mkDefault
    { device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@guix" ];
    };

  fileSystems."/snapshots" = lib.mkDefault
    { device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@snapshots" ];
    };

  fileSystems."/tmp" = lib.mkDefault
    { device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=@tmp" ];
    };

  fileSystems."/btr_pool" = lib.mkDefault
    { device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = [ "subvolid=5" ];
    };

  fileSystems."/swap" = lib.mkDefault
    { device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = [ "subvol=swap" "nodatacow" "noatime" ];
    };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

}
