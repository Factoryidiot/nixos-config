{
  config
  , pkgs
  , inputs
  , ...
}:
let
  # Access the hyprland input via the inputs specialArg passed from flake.nix
  #hyprlandInput = inputs.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
in
{

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

    settings = {};

  };

  services.hyprpolkitagent.enable = true;

}
