{
  nixpkgs
  , pkgs
  , ...
}: {

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

  programs.nano.enable = false;

  users.mutableUsers = false;

}
