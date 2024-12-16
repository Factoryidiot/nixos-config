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
      "/libvirt/qemu/OVMF_CODE.fd" = {
        source = ./secureboot/OVMF_CODE_4M.secboot.fd;
        mode = "0755";
      };
      "/libvirt/qemu/OVMF_VARS.fd" = {
        source = ./secureboot/OVMF_VARS_4M.ms.fd; 
        mode = "0755";
      };
#      "tmpfiles.d/10-looking-glass.conf" = {
#        text = {
#          # Type Path              Mode UID  GID Age Argument
#          f /dev/shm/looking-glass 0660 rhys qemu -
#        };
#     };
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

  # Looking-glass service
  systemd.services.sharedMem = {
    description = "shared memory for looking glass";
    wantedBy = [ "multi-user.target" ];
    script = ''
      touch /dev/shm/looking-glass
      chown ${username}:libvirtd /dev/shm/looking-glass
      chmod 660 /dev/shm/looking-glass
    '';
  };

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
        # CHANGE: use 
        #     ls /nix/store/*OVMF*/FV/OVMF{,_VARS}.fd | tail -n2 | tr '\n' : | sed -e 's/:$//'
        # to find your nix store paths
        verbatimConfig = ''
          nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
        '';

      };
    };
    spiceUSBRedirection.enable = true;
  };

}
