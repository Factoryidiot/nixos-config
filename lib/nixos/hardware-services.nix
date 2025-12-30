# ./modules/nixos/hardware-services.nix
{ ...
}: {

  # Enable Bluetooth management
  services.blueman.enable = true;

  # Wireless Daemon (needed by NetworkManager)
  networking.wireless.iwd.enable = true;


  # Enable UPower service for power/battery status
  services.upower.enable = true;

  # Enable asusctl and supergfxctl for Asus laptops
  services.asusd.enable = true;
  services.supergfxd.enable = true;


}
