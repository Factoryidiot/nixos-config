{
  pkgs,
  lib,
  username,
  ...
}: {

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
      git # required for flakes
      vim
      wget
    ]; 
    variables.EDITOR = "vim";
  };

  hardware.graphics.enable = true;

  i18n.defaultLocale = "en_AU.UTF-8";

  networking = {
    firewall = {
      # allowedTCPPorts = [ 22 80 443 8080 ];
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
    zsh = {
      enable = true;
      loginShellInit = "fastfetch";
      shellInit = 
''
if [ "$TERM" = "linux" ]; then
  ZSH_THEME="robbyrussell"
else
  ZSH_THEME="agnoster"
fi
'';

    };
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
