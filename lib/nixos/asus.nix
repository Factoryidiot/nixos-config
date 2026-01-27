# /lib/nixos/asus.nix
{
  ...
}:
{

  services.asusd = {
    enable = true;
    enableUserService = true;

    asusdConfig.text = ''
     charge_control_end_threshold: 80
     disable_nvidia_powerd_on_batter: true
    '';
  };

  services.supergfxd.enable = true;

}
