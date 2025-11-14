{
  lib
  , pkgs
  , ...
}: {

  environment.systemPackages = with pkgs; [
    yazi
  ];

  programs.yazi.enable = true;

}
