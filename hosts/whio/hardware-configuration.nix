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
    luks.devices."crypted" = { 
      device = "/dev/disk/by-uuid/2da9265d-94a4-485e-8690-eccf82ab5566";
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/433D-31E1";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
  };

  # fileSystems."/btr_pool" = {
  #   device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
  #   fsType = "btrfs"; 
  #   options = [ "subvolid=5" ];
  # };

  fileSystems."/" = { 
    device = "none";
    fsType = "btrfs";
    options = [ "realatime" "mode=755" ];
  };

  fileSystems."/gnu" = {
    device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    fsType = "btrfs";
    options = [ "subvol=@guix" "noatime" "compress-force=zstd:1" ];
  };

  fileSystems."/nix" = { 
    device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    fsType = "btrfs";
    options = [ "subvol=@nix" "noatime" "compress-force=zstd:1" ];
  };

  fileSystems."/persistent" = { 
    device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    fsType = "btrfs";
    options = [ "subvol=@persistent" "compress-force=zstd:1" ];
    neededForBoot = true;
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" "compress-force=zstd:1" ];
  };

  fileSystems."/swap" = {
    device = "";
    fsType = "btrfs";
    options = [ "subvol=@swap" "ro" ];
  };

  fileSystems."/swap/swapfile" = {
    depends = [ "/swap" ];
    device = "/swap/swapfile";
    fstype = "none";
    options = [ "bind" "rw" ];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/766d2f04-c7ed-4f8e-b1da-aeff8570e4af";
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
