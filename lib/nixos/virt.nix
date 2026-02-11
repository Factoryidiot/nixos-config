{ pkgs
, username
, ...
}: {

  users.users.${username}.extraGroups = [ "kvm" "libvirtd" ];

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    swtpm
    virt-viewer
    virtio-win
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu;
        runAsRoot = true;
        # Enable software TPM support for Windows 11.
        swtpm.enable = true;
      };
    };
    # Enable USB redirection. This can be used with any Spice client.
    spiceUSBRedirection.enable = true;
  };
}
