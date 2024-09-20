{
  config,
  lib,
  pkgs,
  username,
  ...
}: {

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        swtpm.enable = true;
        swtpm.package = pkgs.swtpm;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.${username}.extraGroups = [ "libvirt" ];

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
  programs.virt-manager.enable = true;

  home-manager.users.${username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };

  systemd.services."libvirtd".reloadIfChanged = true; # reload vm configs from //services/*/libvirt/guests.nix

}
