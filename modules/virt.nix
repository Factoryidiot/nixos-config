{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  # Geforce RX 4070 Max-Q / Mobile
  gpuIDs = [
    "10de:2860"
    "10de:22bd"
  ];
in {

  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    kernelParams = [
      "amd.iommu=on"
      ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
    ]; # ++ lib.optional cfg.enable ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
  };

  environment.systemPackages = with pkgs; [
    libguestfs
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    virtio-win
    win-spice
  ];

  home-manager.users.${username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };

  programs.virt-manager.enable = true;

  systemd.services."libvirtd".reloadIfChanged = true; # reload vm configs from //services/*/libvirt/guests.nix

  users.users.${username}.extraGroups = [ "libvirtd" ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        runAsRoot = false;
        swtpm.enable = true;
        swtpm.package = pkgs.swtpm;
      };
    };
    spiceUSBRedirection.enable = true;
    waydroid.enable;
 };

}
