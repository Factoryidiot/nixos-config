{
  config
  , lib
  , pkgs
  , username
  , ...
}: {

  environment.systemPackages = with pkgs; [
    config.virtualisation.libvirtd.qemu.package
    libguestfs-with-appliance
    looking-glass-client
    virt-manager
    #virt-viewer
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
