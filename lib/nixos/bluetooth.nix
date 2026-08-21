# ./lib/nixos/bluetooth.nix
{ ...
}: {

  # Disable ERTM, which natively causes pairing and connect/disconnect loops with Xbox controllers
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=Y
  '';

  # Enable Bluetooth management
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    #package = pkgs.bluez-experimental; # Recommended for Series X|S controllers
    settings = {
      General = {
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = "true";
      };
    };
  };

  #+----- Impermanence Persistence -------------
  # Modular persistence: persist Bluetooth pairings and controller connection keys
  environment.persistence."/persistent" = {
    directories = [
      "/var/lib/bluetooth"
    ];
  };

}
