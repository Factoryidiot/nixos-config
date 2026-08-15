# ./modules/nixos/hardware-services.nix
{ lib
, ...
}: {

  # Allow proprietary/redistributable firmware across all hardware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Wireless Daemon (needed by NetworkManager)
  networking.wireless.iwd.enable = true;

  # Enable UPower service for power/battery status
  services.upower.enable = true;

}
