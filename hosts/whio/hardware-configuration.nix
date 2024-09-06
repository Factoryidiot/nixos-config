{ config, lib, pkgs, modulesPath, ... }:

{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "ahci" "nvme" "xhci_pci" "thunderbolt" "sd_mod" "usbhid" "usb_storage" ];
  boot.initrd.kernelModules = [ ];
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

  boot.initrd = {
    luks.devices."crypted" =
    { device = "/dev/disk/by-uuid/2da9265d-94a4-485e-8690-eccf82ab5566";
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  fileSystems."/boot" = lib.mkDefault
    { device = "/dev/disk/by-uuid/433D-31E1";
    #{ device = "/dev/disk/by-partlabel/disk-main-ESP";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/btr_pool" = lib.mkDefault
    { device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    #{ device = "/dev/mapper/crypted";
      fsType = "btrfs"; 
      options = [ "subvolid=5" ];
    };

  fileSystems."/" =
    { device = "btrfs";
      fsType = "btrfs";
      options = [ "relatime" "mode=755" ];
    };

  fileSystems."/gnu" = lib.mkDefault
    { device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    #{ device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=@guix" "noatime" "compress-force=zstd:1" ];
    };

  fileSystems."/nix" = lib.mkDefault
    { device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    #{ device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress-force=zstd:1" ];
    };

  fileSystems."/persistent" = lib.mkDefault
    { device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    #{ device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=@persistent" "compress-force=zstd:1" ];
      neededForBoot = true;
    };

  fileSystems."/snapshots" = lib.mkDefault
    { device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    #{ device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" "compress-force=zstd:1" ];
    };

  fileSystems."/swap" = lib.mkDefault
    { device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    #{ device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=@swap" "ro" ];
    };

  fileSystems."/swap/swapfile" =
    { device = "/swap/swapfile";
      depends = [ "/swap" ];
      fsType = "none";
      options = [ "bind" "rw" ];
    };

  fileSystems."/tmp" = lib.mkDefault
    { device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    #{ device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=@tmp" "compress-force=zstd:1" ];
    };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
