{
  lib
  , pkgs
  , ...
}: {

  # not required.
  #environment.systemPackages = with pkgs; [
  #  yazi
  #];

  programs.yazi.enable = true;

}
