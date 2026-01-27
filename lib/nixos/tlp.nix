# lib/nixos/tlp.nix
{
  ...
}: {

  services.tlp = {
    enable = true;

    settings = {
      ## Adaptive Backlight Modulation
      AMDGPU_ABM_LEVEL_ON_AC = 0; # 0 ABM off
      AMDGPU_ABM_LEVEL_ON_BAT = 3; # 1 to 4 max brightness reduction allowed by ABM
      # 1 is least and 4 is most power saving
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      RUNTIME_PM_ON_AC = "auto";

      START_CHARGE_THRESH_BAT0 = 20; # at 20 or below start to charge
      STOP_CHARGE_THRESH_BAT0 = 0; # Disabled to avoid conflict with asusd

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

}
