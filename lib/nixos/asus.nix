# /lib/nixos/asus.nix
{ inputs
, lib
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
  };

# 2. Tell D-Bus where to find the service definition
  services.dbus.packages = [ unstable-asusctl ];

  services.supergfxd.enable = true;
  # 3. Create a MUTABLE config file instead of a read-only symlink
  system.activationScripts.asusd-config = lib.stringAfter [ "stdio" ] ''
    mkdir -p /etc/asusd
    cat <<EOF > /etc/asusd/asusd.ron
(
  charge_control_end_threshold: 80,
  base_charge_control_end_threshold: 80,
  disable_nvidia_powerd_on_battery: true,
  platform_profile_linked_epp: true,
  platform_profile_on_battery: Quiet,
  change_platform_profile_on_battery: true,
  platform_profile_on_ac: Performance,
  change_platform_profile_on_ac: true,
)
EOF
    # Ensure the daemon (running as root) can definitely handle it
    chmod 644 /etc/asusd/asusd.ron
  '';

  systemd.services.supergfxd.serviceConfig.ExecStart = [
    "" # This clears the existing command
    "${unstable-supergfxctl}/bin/supergfxd"
  ];


}
