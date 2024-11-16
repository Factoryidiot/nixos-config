{
  nixos-hardware
  , lib
  , pkgs
  , username
  , ...
}: {

  imports = [
    # Additional hardware specific configuration
    # https://github.com/NixOS/nixos-hardware
    nixos-hardware.nixosModules.asus-battery
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-gpu-amd
    # nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  hardware.cpu.amd.updateMicrocode = true;

  nix = {

    settings = {
      accept-flake-config = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ username ];
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

  console  = {
    # font = ;
    keyMap = "us";
    # useXkbConfig = true;
  };

  environment = {
    systemPackages = with pkgs; [
      clinfo
      curl
      git # required for flakes
      lshw
      pciutils
      pulseaudioFull
      wireplumber
      usbutils
      vim
      wget
    ]; 
    variables.EDITOR = "vim";
  };

  hardware = {
    bluetooth.enable = true;
  };

  i18n.defaultLocale = "en_NZ.UTF-8";

  networking = {
    firewall = {
      # allowedTCPPorts = [ 22 80 443 8080 ];
      # allowedUDPPorts = [ ... ];
      enable = false;
    };
    # networking.wireless.enable = true;
    wireless.iwd.enable = true;
    networkmanager.enable = true;
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
      enableSSHSupport = true;
    };
    nano.enable = false;
    zsh = {
      enable = true;
    };
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
    tlp.enable = true;
    upower.enable = true;
    # pulseaudio.enable = true;
    # printing.enable = true
  }; 

  time.timeZone = "Australia/Brisbane";
  # time.timeZone = "Pacific/Auckland";

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = true;

    groups = {};

    users.root = {
       initialHashedPassword = "$7$CU..../....XaFP2ISgvPZc.mYeUHWQx.$V1f6AYOWu77klTUZb.9nmwshOLBiE7cFxMjIrXPvrE7";
    };
    users.${username} = {
      isNormalUser = true;
      description = username;
      extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
      initialHashedPassword = "$7$CU..../....XaFP2ISgvPZc.mYeUHWQx.$V1f6AYOWu77klTUZb.9nmwshOLBiE7cFxMjIrXPvrE7";
     };

  };
}
