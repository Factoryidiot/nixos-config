{
  config
  , pkgs
  , ...
}: { 
 imports = [
    # Hardware first
    ./hardware-configuration.nix

    #../../modules/tlp.nix

    ../../modules/zram.nix

    ../../modules/configuration.nix
    ../../modules/fonts.nix

  ];

  environment = {
    systemPackages = with pkgs; [
      qemu
    ];
  };

  hardware = {
    # bluetooth.enable = true;
  };

  #i18n.defaultLocale = "en_AU.UTF-8";
  i18n.defaultLocale = "en_NZ.UTF-8";

  networking = {
    hostName = "whio-qemu";
  };

  #time.timeZone = "Australia/Brisbane";
  time.timeZone = "Pacific/Auckland";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
