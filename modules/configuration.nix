# modules/configuration.nix
{
  nixos-hardware
  , lib
  , pkgs
  , username
  , ...
}: {

  # NOTE: Hardware modules are commented out as they are often best placed 
  # in the specific host's default.nix, or if necessary, here.
  # imports = [
  #   nixos-hardware.nixosModules.common-pc-laptop
  #   ...
  # ];

  hardware.cpu.amd.updateMicrocode = true;

  # -------------------------------------------------------------------------
  # NIX CONFIGURATION
  # -------------------------------------------------------------------------

  nix = {
    settings = {
      accept-flake-config = true;
      experimental-features = [ "nix-command" "flakes" ];
      # Add the user to the trusted list for better performance
      trusted-users = [ username "@wheel" ]; 
      substituters = [
        "https://cache.nixos.org"
      ];
    };

    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # -------------------------------------------------------------------------
  # CORE ENVIRONMENT
  # -------------------------------------------------------------------------

  console  = {
    keyMap = "us";
  };

  environment = {
    systemPackages = with pkgs; [
      clinfo
      curl
      git # required for flakes
      lshw
      pciutils
      usbutils
      vim
      wget
    ];
    variables.EDITOR = "vim";
  };

  # -------------------------------------------------------------------------
  # NETWORKING & SERVICES
  # -------------------------------------------------------------------------

  networking = {
    firewall.enable = true; # Enabled for security (must be true for OpenSSH rule to work)
    wireless.iwd.enable = true;
    # networking.networkmanager.enable removed as it's defined in host's default.nix
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
      enableSSHSupport = true;
    };
    nano.enable = false;
    zsh.enable = true;
  };

  services = {
    blueman.enable = true;
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # tlp.enable removed as it is host-specific (laptop only)

    upower.enable = true;
  };

  # -------------------------------------------------------------------------
  # USER & SHELL
  # -------------------------------------------------------------------------

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = true;
  };
}
