## due to a whole bunch if issues with NIXOS and it's idiosyncrasies I have abandoned this module for now
## NIXOS has rubbish documentation

{ lib
, pkgs
, ...
}:
let
  grpIDs = [
    "10de:2860" # Geforce RX 4070 Max-Q / Mobile  0000:01:00.0
    "10de:22bd" # Audio Controller                0000:01:00.1
  ];
in
{

  boot = {
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];

    #    kernelModules = [
    #      "vfio_pci"
    #      "vfio"
    #      "vfio_iommu_type1"
    #     # "vfio_virqfd" depricated and now included in vfio
    #    ];
    kernelParams = [
      "amd.iommu=on"
      #      "vfio-pci.ids=${lib.concatStringsSep "," grpIDs}"
    ]; # ++ lib.optional cfg.enable ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);

  };

  environment.etc = {

    "libvirt/hooks/qemu.d/workspace/prepare/begin/start.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash
        set -x

        VIRSH_GPU_VIDEO=pci_0000_01_00_0
        VIRSH_GPU_AUDIO=pci_0000_01_00_1

        # Unbind VTconsole
        echo 0 > /sys/class/vtconsole/vtcon0/bind
        echo 0 > /sys/class/vtconsole/vtcon1/bind

        # Unbind EFI Framebuffer
        # echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

        sleep 2

        # Unload Nvidia kernel modules
        modprobe -r nvidia_drm nvidia_uvm nvidia_modeset

        sleep 2

        # Detach GPU devices from host
        virsh nodedev-detach $VIRSH_GPU_VIDEO
        virsh nodedev-detach $VIRSH_GPU_AUDIO

        # Load VFIO module
        modprobe vfio_pci_core # vfio vfio_pci_core vfio_iommu_type1
      '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/workspace/prepare/end/stop.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash
        set -x

        VIRSH_GPU_VIDEO=pci_0000_01_00_0
        VIRSH_GPU_AUDIO=pci_0000_01_00_1

        # Attach GPU devices to host
        virsh nodedev-reattach $VIRSH_GPU_VIDEO
        virsh nodedev-reattach $VIRSH_GPU_AUDIO

        # Load VFIO module
        modprobe -r vfio_pci vfio_pci_core vfio_iommu_type1 vfio

        # Bind framebuffer to host
        # echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind 

        # Load Nvidia modules
        # modprobe nvidia_drm # nvidia_uvm nvidia_modeset nvidia

        # Bind VTconsole
        echo 1 > /sys/class/vtconsole/vtcon0/bind
        echo 1 > /sys/class/vtconsole/vtcon1/bind
      '';
      mode = "0755";
    };

  };

  system.activationScripts.libvirt-hooks.text = ''
    #   ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks/
       ln -sfn /etc/libvirt/hooks /var/lib/libvirt/hooks/
  '';

}
