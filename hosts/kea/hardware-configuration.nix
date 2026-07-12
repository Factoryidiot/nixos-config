# /hosts/kea/hardware-configuration.nix
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  # Optimized for the SSD
  ssdOptions = [ "noatime" "compress=zstd:1" "ssd" "discard=async" ];
  
  # Optimized for the HDD (no "ssd" flag, higher compression to cut down mechanical I/O)
  hddOptions = [ "noatime" "compress=zstd:3" ];

  # UUID Placeholders - to be filled post-format
  ssdUuid = "SSD_BTRFS_UUID";
  hddUuid = "HDD_BTRFS_UUID";
  swapUuid = "HDD_SWAP_UUID";
  bootUuid = "BOOT_ESP_UUID";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader setup
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Hardware/Platform Adjustments (Intel/NVIDIA platform)
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.systemd.enable = true;
  
  # Removed AMD-specific params, kept standard KVM/Intel modules
  boot.kernelParams = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.tmp.cleanOnBoot = true;

  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];

  # LUKS Decryption Placeholders (Matching the new Disko configuration names)
  boot.initrd.luks.devices."crypted_ssd" = {
    device = "/dev/disk/by-uuid/SSD_LUKS_UUID";
    allowDiscards = true;
    bypassWorkqueues = true;
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  };

  boot.initrd.luks.devices."crypted_hdd" = {
    device = "/dev/disk/by-uuid/HDD_LUKS_UUID";
    allowDiscards = true;
    bypassWorkqueues = true;
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  };

  # File Systems - Boot / EFI
  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${bootUuid}";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # File Systems - Stateless Root Top-Level
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "relatime" "mode=755" ];
  };

  # File Systems - SSD Btrfs Subvolumes
  fileSystems."/btr_pool" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${ssdUuid}"; 
    fsType = "btrfs";
    options = [ "subvolid=5" ];
  };

  fileSystems."/gnu" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${ssdUuid}"; 
    fsType = "btrfs";
    options = ssdOptions ++ [ "subvol=@guix" ];
  };

  fileSystems."/nix" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${ssdUuid}"; 
    fsType = "btrfs";
    options = ssdOptions ++ [ "subvol=@nix" ];
  };

  fileSystems."/persistent" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${ssdUuid}"; 
    fsType = "btrfs";
    options = ssdOptions ++ [ "subvol=@persistent" ];
    neededForBoot = true;
  };

  fileSystems."/snapshots" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${ssdUuid}"; 
    fsType = "btrfs";
    options = ssdOptions ++ [ "subvol=@snapshots" ];
  };

  fileSystems."/tmp" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${ssdUuid}"; 
    fsType = "btrfs";
    options = ssdOptions ++ [ "subvol=@tmp" ];
  };

  # File Systems - HDD Btrfs Subvolume
  fileSystems."/storage" = lib.mkDefault {
    device = "/dev/disk/by-uuid/${hddUuid}";
    fsType = "btrfs";
    options = hddOptions ++ [ "subvol=@storage" ];
  };

  # Dedicated Swap Space on HDD
  swapDevices = [
    { device = "/dev/disk/by-uuid/${swapUuid}"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  
  # Flipped microcode to Intel
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
