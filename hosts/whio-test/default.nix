# hosts/whio-test/default.nix
{
  config
  , pkgs
  , specialArgs
  , ...
}:
  let
  # Destructure 'username' and 'hostname' from the specialArgs passed from flake.nix
  inherit (specialArgs) username hostname;
in
{

  imports = [
    ./hardware-configuration.nix
    ./persistence.nix                 # Impermanence configuration (to be defined)
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

  # Essential for TPM LUKS unlock and Secure Boot (systemd-boot UKI)
  boot.initrd.systemd.enable = true;
  security.tpm2.enable = true;
  security.tpm2.abrmd.enable = true;

  # -------------------------------------------------------------------------
  # USER & SECURITY (Host Specific Overrides)
  # -------------------------------------------------------------------------

  # Override or merge specific user settings from the common module (wheel is inherited/merged)
  users.users.${username} = {
    # Add host-specific groups. This list is merged with 'wheel' from configuration.nix.
    extraGroups = [ "networkmanager" ]; 
    # Define the host-specific password hash
    initialHashedPassword = "$7$GU..../....D9JHs.HM1v/Vf9EuyfDFS1$kWoMCdPjd1hv5myViGmPyb3.rJYKjiZ16MeaeyKSlE8";


  };

  # Allow members of 'wheel' to use sudo without a password (common for single-user systems)
  security.sudo.wheelNeedsPassword = false;

  # -------------------------------------------------------------------------
  # ENVIRONMENT & HARDWARE
  # -------------------------------------------------------------------------

  environment.systemPackages = with pkgs; [
  ];

}
