{ pkgs, ... }:

{
  # This module is self-enabling to be consistent with other desktop modules.
  programs.fcitx5.enable = true;

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
}
