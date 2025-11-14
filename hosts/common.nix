{
  lib
  , inputs
  , nixpkgs
  , pkgs
  , username
  , ...
}: {

  imports = [
    ../lib/yazi.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      clinfo
      curl
      git
      lshw
      pciutils
      stow
      usbutils
      vim
      wget
    ];
    variables.EDITOR = "vim";
  };

# -------------------------------------------------------------------------
# NETWORKING & SERVICES
# -------------------------------------------------------------------------


  programs = {

    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
      enableSSHSupport = true;
    };
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
