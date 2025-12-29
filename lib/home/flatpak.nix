# lib/home/flatpak.nix
{ config, pkgs, lib, ... }:

{
  options.programs.flatpak = {
    enable = lib.mkEnableOption "flatpak";
  };

  config = lib.mkIf config.programs.flatpak.enable {
    home.packages = with pkgs; [
      flatpak
    ];

    xdg.configFile = {
      "flatpak/flatpak.conf".source = "${config.home.homeDirectory}/.dotfiles/flatpak/flatpak.conf";
    };
  };
}
