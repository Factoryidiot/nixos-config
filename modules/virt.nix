{
  pkgs 
  , username
  , ...
}: {

  environment = {
    systemPackages = with pkgs; [
      looking-glass-client
      spice 
      spice-gtk
      spice-protocol
      virt-manager
    ];
    etc = {
      "tmpfiles.d/10-looking-glass.conf" = {
        text = {
          # Type Path              Mode UID  GID Age Argument
          f /dev/shm/looking-glass 0660 rhys qemu -
        };
      };
    };
  };

  home-manager.users.${username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };

  programs.virt-manager.enable = true;

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
          packages = with pkgs; [ OVMFFull ];
#          packages = with pkgs; [ (OVMFFull.override {
#          packages = with pkgs; [
#            (OVMF.override {
#              msVarsTemplate = true;
#	      secureBoot = true;
#              tpmSupport = true;
#            })
#            }).fd
#          ];
	};
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

}
