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
    enableZshIntegration = true;
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

  programs.tmux = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
  };

  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      #theme = "nord-extended/nord"
    };

    plugins = [
    
    ];
    # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #shellInit = ''
    #echo ""
    #if [[ $(tty) == *"pts"* ]]; then
    #  fastfetch
    #fi
    #'';

  };

}
