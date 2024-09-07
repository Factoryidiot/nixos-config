{ pkgs, lib, username, ... }:

{

  imports = [];

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
      curl
      git
      vim
      wget
    ]; 
    variables.EDITOR = "vim";
  };

  hardware.graphics.enable = true;

  i18n.defaultLocale = "en_AU.UTF-8";

  networking = {
    firewall = {
      allowedTCPPorts = [ 22 80 443 8080 ];
      # allowedUDPPorts = [ ... ];
      enable = false;
    };
    # networking.wireless.enable = true;
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
    zsh.enable = true;
  };

  services = {
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
    # pulseaudio.enable = true;
    # printing.enable = true
  }; 

  time.timeZone = "Australia/Brisbane";

  users = {
    mutableUsers = true;

    groups = {};

    users.root = {
       initialHashedPassword = "$5$Nj9bUYRY9JrqUXIy$pNFGfzODNx9uV6TXMlW1qZtIEBfLXjkFoSic5/kZtiA";
    };

    users.${username} = {
      isNormalUser = true;
      description = username;
      # initialHashedPassword = "$5$Nj9bUYRY9JrqUXIy$pNFGfzODNx9uV6TXMlW1qZtIEBfLXjkFoSic5/kZtiA";
      extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
     };

  };
}
