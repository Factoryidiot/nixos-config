{
  lib
  , inputs
  , nixpkgs
  , pkgs
  , username
  , ...
}: {

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

    # Garbage Collection
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
# Time and Locale settings moved to host-specific files

  console = {
    keyMap = "us";
  };

  environment = {
    systemPackages = with pkgs; [
      clinfo
      curl
      git
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
    firewall.enable = true;                                 # Universal default firewall setting
    wireless.iwd.enable = true;                             # IWD is often a core networking tool
    # The network manager choice (like networkmanager.enable) is left to the host file
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

    upower.enable = true;
  };

# -------------------------------------------------------------------------
# USER & SHELL (COMMON DEFINITION)
# -------------------------------------------------------------------------

  users = {
    defaultUserShell = pkgs.zsh;
  };

}
