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
    ./persistence.nix                 # Preservation configuration 
  ];

  # -------------------------------------------------------------------------
  # CORE SYSTEM SETUP (Host Specific)
  # -------------------------------------------------------------------------

  # Time and locale are specific to the physical location
  time.timeZone = "Pacific/Auckland"
  i18n.defaultLocale = "en_NZ.UTF-8";
  
  networking = {
    hostName = hostname;
    # Network manager is host-specific, using it implies needing the 'networkmanager' group
    networkmanager.enable = true;
  };

  # -------------------------------------------------------------------------
  # USER & SECURITY (Host Specific Overrides)
  # --------------------------------f----------------------------------------

  # Override or merge specific user settings from the common module (wheel is inherited/merged)
  users = {
    # mutableUsers = false;
    users.${username} = {

      isNormalUser = true;
      # Add host-specific groups. This list is merged with 'wheel' from configuration.nix.
      extraGroups = [ "networkmanager" "wheel" ]; 
    };
  };

  # Allow members of 'wheel' to use sudo without a password (common for single-user systems)
  security.sudo.wheelNeedsPassword = false;

}
