# ./lib/nixos/dell.nix
{ pkgs
, ...
}: {

  # Dell hardware and power management utilities
  environment.systemPackages = with pkgs; [
    libsmbios # Provides smbios-battery-ctl and Dell WMI utilities
  ];

  # TLP power management for battery threshold control (80% max charge)
  services.tlp = {
    enable = true;
    settings = {
      # Battery charging thresholds for Dell laptops (BAT0)
      START_CHARGE_THRESH_BAT0 = 50; # Start charging when below 50%
      STOP_CHARGE_THRESH_BAT0 = 80; # Stop charging when reaching 80%

      # Performance tuning on AC vs Battery
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
    };
  };

  # Intel thermal management daemon to prevent thermal throttling
  services.thermald.enable = true;

}
