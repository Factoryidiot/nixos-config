{
  lib
  , ...
}: {

  environment.systemPackages = with pkgs; [
    yazi
  ];

  programs.yzai.enable;

}
