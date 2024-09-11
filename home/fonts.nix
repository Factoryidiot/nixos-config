{
  pkgs,
  ...
}: {

  enableDefaultPackages = false;
  fontDir.enable = true;

  packages = with pkgs; [
    material-design-icons
    font-awesome
  ];

}
