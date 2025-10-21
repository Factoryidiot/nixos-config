# hosts/whio-qemu/default.nix
{
  config
  , pkgs
  , specialArgs
  , ...
}:
  let
  # Destructure 'username' from the specialArgs passed from flake.nix
  inherit (specialArgs) username;
in
{
  imports = [
    # 1. Host-specific disk and security setup
    ./hardware-configuration.nix
    ./persistence.nix  # Impermanence configuration (to be defined)
  ];

  # -------------------------------------------------------------------------
  # CORE SYSTEM SETUP
  # -------------------------------------------------------------------------

  networking = {
    hostName = "whio-qemu";
  };

  # Essential for TPM LUKS unlock and Secure Boot (systemd-boot UKI)
  boot.initrd.systemd.enable = true;
  security.tpm2.enable = true;
  security.tpm2.abrmd.enable = true;

  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";

  # -------------------------------------------------------------------------
  # USER & SECURITY
  # -------------------------------------------------------------------------

  # Define the core system user (Home Manager handles the environment)
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Grant sudo and networking access
    # IMPORTANT: Set a password for initial login
    # For a temporary VM, a clear password might be acceptable:
    # initialHashedPassword = ""; 
    # Or, use a properly generated hash:
    hashedPassword = "$6$tz.Q5qBoM24gmIhB$S/wR6A7KIzwqBQG55VwduBSuKutS3Bd45ypzD0nPoXis6qszRhoN1aJG6hXFY/K6tYsIwJyfNvYXBt.1mCoH10";
  };
  # Allow members of 'wheel' to use sudo without a password (common for single-user systems)
  security.sudo.wheelNeedsPassword = false;

  # -------------------------------------------------------------------------
  # ENVIRONMENT & HARDWARE
  # -------------------------------------------------------------------------
  
  environment.systemPackages = with pkgs; [
  ];

}
