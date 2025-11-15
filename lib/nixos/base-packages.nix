# ./modules/nixos/base-packages.nix
{ 
  config
  , lib
  , pkgs
  , specialArgs
  , ...
}
let
  # Inherit username from specialArgs to configure trusted users
  inherit (specialArgs) username;
in
{

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

  console.keyMap = "us";

  programs.nano.enable = false;

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

  users.defaultUserShell = pkgs.zsh;

}
