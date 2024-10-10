{
  config,
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
    ./vfio.nix
  ];

  boot = {
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
#      "nvidia_drm"
#      "nvidia_modeset"
#      "i2c_nvidia_gpu"
    ];
#   extraModprobeConfig = ''
#      softdep drm pre: vfio-pci
#      softdep nouveau pre: vfio-pci
#      softdep nvidia pre: vfio-pci
#    '';
#
    initrd.kernelModules = [
#    #  "vfio_virqfd" depricated and now included in vfio
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
    config.virtualisation.libvirtd.qemu.package
    libguestfs-with-appliance
    looking-glass-client
    virt-manager
    virt-viewer
    virtiofsd
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

#  systemd.services."libvirtd".reloadIfChanged = true; # reload vm configs from //services/*/libvirt/guests.nix

  system.activationScripts.libvirt-hooks.text = ''
    ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks/
  '';

  systemd.services.libvirtd = {
    path = 
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            sd
            coreutils
            sudo 
            su 
            killall
            procps
            util-linux
            bindfs
            qemu-utils
            psmisc
            procps
          ];
        };
      in
        [ env ];
  };

  users.users.${username}.extraGroups = [ "libvirtd" ];

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_full;
        # package = pkgs.qemu_kvm;
        ovmf = {
	  enable = true;
          packages = [ (pkgs.OVMF.override {
	    secureBoot = true;
	    tpmSupport = true;
	  }).fd ];
	};
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
 };

}
