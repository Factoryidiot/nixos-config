{
  config
  , pkgs
  , ...
}: { 
 imports = [
    # Hardware first
    ./hardware-configuration.nix

    ../../modules/tlp.nix

    ../../modules/nvidia.nix      
    #../../modules/vfio.nix
    ../../modules/virt.nix
    ../../modules/zram.nix

    ../../modules/configuration.nix
    ../../modules/fonts.nix

    ../../programs/steam.nix
  ];

  boot = {
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
      argsOverride = rec {
        src = pkgs.fetchurl {
                url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
                sha256 = "2c56dac2b70859c16b4ef651befb0d28c227498bd3eee08e8a45a357f22dd3b7";
              };
        version = "6.6.49";
        modDirVersion = "6.6.49";
      };
    });
    kernelParams = [
      "amd.iommu=on" 
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      adwaita-icon-theme
      asusctl
      awscli2
      bibata-cursors
      brightnessctl
      firefox
      hyprcursor # needs to be removed from base config
      playerctl
      pulseaudioFull
      supergfxctl
   ];
  };

  hardware = {
    bluetooth.enable = true;
  };

  #i18n.defaultLocale = "en_AU.UTF-8";
  i18n.defaultLocale = "en_NZ.UTF-8";

  networking = {
    hostName = "whio";
  };

  #time.timeZone = "Australia/Brisbane";
  time.timeZone = "Pacific/Auckland";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
