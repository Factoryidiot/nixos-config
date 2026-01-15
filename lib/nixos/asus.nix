# /lib/nixos/asus.nix
{ config, pkgs, ... }:
{

  services.asusd = {
    enable = true;
    asusdConfig.text = ''
      (
          charge_limit: Some(80),
      )
    '';
  };
  services.supergfxd.enable = true;

}
