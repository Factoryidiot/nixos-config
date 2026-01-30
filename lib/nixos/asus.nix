# /lib/nixos/asus.nix
{ inputs
, pkgs
,  ...
}:
let
  unstable-asusctl = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.asusctl;
  unstable-supergfxctl = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.supergfxctl;
in
{

  services.asusd = {
    enable = true;
    enableUserService = true;
    package = unstable-asusctl;

    asusdConfig.text = ''
     [battery]
     charge_control_end_threshold = 80

     [graphics]
     disable_nvidia_powerd_on_battery = true
    '';
  };

  services.supergfxd.enable = true;

  systemd.services.supergfxd.serviceConfig.ExecStart = [
    "" # This clears the existing command
    "${unstable-supergfxctl}/bin/supergfxd"
  ];

  environment.systemPackages = [
    unstable-asusctl
    unstable-supergfxctl
  ];

}
