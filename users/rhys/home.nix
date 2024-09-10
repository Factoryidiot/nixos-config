{
  pkgs,
  ...
}: {

  imports = [
    ../../home/core.nix

    ../../home/fastfetch.nix
    ../../home/git.nix
    ../../home/neovim.nix
    ../../home/zsh.nix
  ];

  programs.git = {
    userName = "Factoryidiot";
    userEmail = "rhys.scandlyn@gmail.com";
  };

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zsh = {
    history = {
      size = 1000;
    };

    #shellInit = ''
    #echo ""
    #if [[ $(tty) == *"pts"* ]]; then
    #  fastfetch
    #fi
    #'';

  };

}
