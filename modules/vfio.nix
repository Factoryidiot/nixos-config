{
  ... 
}:
let
  grpIDs = [
    "10de:2860" # Geforce RX 4070 Max-Q / Mobile  0000:01:00.0
    "10de:22bd" # Audio Controller                0000:01:00.1
  ];
in {

  boot = {
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
    ];

    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
     # "vfio_virqfd" depricated and now included in vfio
    ];
    kernelParams = [
      "amd.iommu=on" 
      "vfio-pci.ids=${lib.concatStringsSep "," grpIDs}"
    ]; # ++ lib.optional cfg.enable ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);

  };


  environment.etc = {

    "libvirt/hooks/qemu.d/workspace/prepare/begin/start.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash
        VIRSH_GPU_VIDEO=pci_0000_01_00_0
        VIRSH_GPU_AUDIO=pci_0000_01_00_1

        # Unbind VTconsole
        echo 0 > /sys/class/vtconsole/vtcon0/bind
        echo 0 > /sys/class/vtconsole/vtcon1/bind

        # Unbind EFI Framebuffer
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

        # Detach GPU devices from host
        virsh nodedev-detach $VIRSH_GPU_VIDEO
        virsh nodedev-detach $VIRSH_GPU_AUDIO
      '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/workspace/prepare/end/stop.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash

        # Bind VTconsole
        echo 1 > /sys/class/vtconsole/vtcon0/bind
        echo 1 > /sys/class/vtconsole/vtcon1/bind

        # Bind EFI Framebuffer
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind
      '';
      mode = "0755";
    };

  };

  #system.activationScripts.libvirt-hooks.text = ''
  #  ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks/
  #'';

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

}
