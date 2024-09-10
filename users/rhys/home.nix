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

  programs.fzf = {
    enable = true;
    enableZshIntergration = true;
  };

  programs.git = {
    userName = "Factoryidiot";
    userEmail = "rhys.scandlyn@gmail.com";
  };

  programs.kitty = {
    enable = true;
  };

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.yazi = {
    enable = true;
  };

  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      #theme = "nord-extended/nord"
    };

    plugins = [
    
    ];
    #shellInit = ''
    #echo ""
    #if [[ $(tty) == *"pts"* ]]; then
    #  fastfetch
    #fi
    #'';

  };

}
