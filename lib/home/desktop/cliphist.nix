# lib/home/desktop/cliphist.nix
{ pkgs
, ...
}:
{

  services.cliphist = {
    enable = true;
  };

  home.packages = with pkgs; [
    cliphist
  ];

}
