{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.fcitx5;
in
{
  options.programs.fcitx5 = {
    enable = mkEnableOption "Enable fcitx5";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-mozc # Japanese
          # fcitx5-chewing # Chinese
          # fcitx5-hangul # Korean
        ];
      };
    };

    home.packages = with pkgs; [
      # Add any fcitx5 themes or other related packages here
    ];
  };
}
