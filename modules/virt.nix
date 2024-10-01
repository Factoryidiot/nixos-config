{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
let
  grpIDs = [
    "10de:2860" # Geforce RX 4070 Max-Q / Mobile
    "10de:22bd" # Audio Controller
  ];
in {

  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia

    # TODO: why do I get the below error?
    # error: The option `hardware.intelgpu.loadInInitrd' in `/nix/store/4mgg9mrh8g0qj4g3z9zvqhrniig10bsn-source/systems/evo/hardware/gpus.nix' is already declared in `/nix/store/75hvhrfigcnckibdlg877157bpwjmy85-source/common/gpu/intel'.
    # Where is the other coming from?g
    # inputs.nixos-hardware.nixosModules.common-gpu-intel
  ];

  boot = {
    blacklistedKernelModules = [
      "nouveau"
      #"nvidia"
      #"nvidia_drm"
      #"nvidia_modeset"
      #"i2c_nvidia_gpu"
    ];
    extraModprobeConfig = ''
      softdep drm pre: vfio-pci
      softdep nouveau pre: vfio-pci
      softdep nvidia pre: vfio-pci
    '';

    initrd.kernelModules = [
    #  "vfio_virqfd" depricated and now included in vfio
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    kernelParams = [
      "amd.iommu=on" 
      "vfio-pci.ids=${lib.concatStringsSep "," grpIDs}"
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
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
	        enable = true;
          packages = [ (pkgs.OVMF.override {
	          secureBoot = true;
	          tpmSupport = true;
	        }).fd ];
	      };
        runAsRoot = true;
        #swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
    # waydroid.enable;
 };

}
