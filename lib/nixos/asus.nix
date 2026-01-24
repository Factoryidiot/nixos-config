# /lib/nixos/asus.nix
{
  ...
}:
{

  services.asusd = {
    enable = true;
    # battery_charge_limit = 80;
  };

  services.supergfxd.enable = true;

}
