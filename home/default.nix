{
  inputs
  , pkgs
  , username
  , ...
}: {

  home = {
    inherit username;

    packages = with pkgs; [
      firefox
      google-chrome
      hyprland
      alacritty
      waybar
      wayland
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
 
  };

  # Let Home Manager install and manage itself.
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

}
