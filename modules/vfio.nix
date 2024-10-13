{
  ... 
}: {

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

}
