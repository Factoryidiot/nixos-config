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
    ./disko.nix        # Disk partitioning and Btrfs setup
    ./persistence.nix  # Impermanence configuration (to be defined)

    # 2. Global modules
    ../../modules/configuration.nix # Core system packages, services, etc.
    ../../modules/secureboot.nix   # Lanzaboote/Secure Boot setup (to be defined)
    #../../modules/tlp.nix # TLP is for laptops; often excluded in QEMU
    ../../modules/zram.nix
  ];

  # -------------------------------------------------------------------------
  # CORE SYSTEM SETUP
  # -------------------------------------------------------------------------

  networking = {
    hostName = "whio-qemu";
    networkmanager.enable = true; # Enable graphical/standard networking
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
    hashedPassword = "$6$salt$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
  };
  # Allow members of 'wheel' to use sudo without a password (common for single-user systems)
  security.sudo.wheelNeedsPassword = false;

  # -------------------------------------------------------------------------
  # ENVIRONMENT & HARDWARE
  # -------------------------------------------------------------------------
  
  environment.systemPackages = with pkgs; [
    # qemu is useful if you plan to run VMs *inside* the VM, otherwise remove it
    # qemu
    git # Essential for post-install setup and management
    vim # Or your preferred editor for post-install config
  ];

  # hardware = {
  #   bluetooth.enable = true; # Keep commented out for VM, unless specifically needed
  # };

  # -------------------------------------------------------------------------
  # NIXOS RELEASE
  # -------------------------------------------------------------------------

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken.
  system.stateVersion = "25.05";
}
