{
  pkgs 
  , username
  , ...
}: {

  environment = {
    systemPackages = with pkgs; [
      spice 
      spice-gtk
      spice-protocol
      virt-manager
    ];
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

  environment.etc = {
    "/run/libvirt/nix-ovmf/OVMF_CODE.4M.secboot.fd" = {
      source = "./secureboot/OVMF_CODE.4M.secboot.fd";
  };

  "/run/libvirt/nix-ovmf/OVMF_VARS.4M.ms.fd" = {
    source = "./secureboot/OVMF_CODE.4M.ms.fd";
  };
}; 

}
