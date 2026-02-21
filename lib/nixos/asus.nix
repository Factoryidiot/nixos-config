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

  environment.systemPackages = [
    unstable-asusctl
    unstable-supergfxctl
  ];

  services.asusd = {
    enable = true;
    enableUserService = true;
    package = unstable-asusctl;
    asusdConfig.text = ''
      (
        charge_control_end_threshold: 80,
        base_charge_control_end_threshold: 80,
        disable_nvidia_powerd_on_battery: true,
        ac_command: "",
        bat_command: "",
        platform_profile_linked_epp: true,
        platform_profile_on_battery: Quiet,
        change_platform_profile_on_battery: true,
        platform_profile_on_ac: Performance,
        change_platform_profile_on_ac: true,
        profile_quiet_epp: Power,
        profile_balanced_epp: BalancePower,
        profile_custom_epp: Performance,
        profile_performance_epp: Performance,
        ac_profile_tunings: {
          Performance: (
            enabled: false,
            group: {},
          ),
        },
        dc_profile_tunings: {},
        armoury_settings: {},
      )
    '';
  };

  #services.dbus.packages = [ unstable-asusctl ];
  services.supergfxd.enable = true;

  #systemd.services.asus-battery-enforcer = {
  #  description = "Force ASUS battery limit to 80% at boot";
  #  after = [ "asusd.service" "multi-user.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #    # We use asusctl directly to ensure the kernel gets the message
  #    ExecStart = "${unstable-asusctl}/bin/asusctl battery-limit 80";
  #  };
  #};

  #systemd.services.supergfxd.serviceConfig.ExecStart = [
  #  "" # This clears the existing command
  #  "${unstable-supergfxctl}/bin/supergfxd"
  #];


}
