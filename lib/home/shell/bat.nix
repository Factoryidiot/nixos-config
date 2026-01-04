# lib/home/shell/bat.nix
{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ 
      prettybat
      batdiff
      batman
      batgrep
      batwatch
    ];
    config = {
      pager = "less -FR";
    };
  };
}
