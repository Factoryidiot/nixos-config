# hosts/whio-test/default.nix
{
  config
  , pkgs
  , specialArgs
  , ...
}:
  let
  # Destructure 'hostname' from the specialArgs passed from flake.nix
  inherit (specialArgs) hostname;
in
{

  imports = [
    # Host specific configuration
    ./hardware-configuration.nix
    ./persistence.nix                 # Preservation configuration

    # Basic configuration
    ../../hosts/common.nix

    # Additional configuration 
    #../../modules/fonts.nix
    #../../modules/zram.nix

    ../../lib/fastfetch.nix

  ];

  # -------------------------------------------------------------------------
  # CORE SYSTEM SETUP (Host Specific)
  # -------------------------------------------------------------------------

  # Time and locale are specific to the physical location
  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";
  
  networking = {
    hostName = hostname;
    # Network manager is host-specific, using it implies needing the 'networkmanager' group
    networkmanager.enable = true;
  };

}
