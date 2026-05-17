# ./lib/home/shell/bat.nix
{ 
  pkgs,
  ...
}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
    extraPackages = with pkgs.bat-extras; [
      prettybat
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  programs.zsh = {
    shellAliases = {
      cat="bat";
    };
  };

}
