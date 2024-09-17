{
  #config,
  #lib,
  pkgs,
  ...
}: {


  

  imports = [

    ../../home/core.nix

    ../../home/fastfetch.nix
    ../../home/git.nix
    ../../home/neovim.nix
    ../../home/zsh.nix

    ../../home/hyprland.nix
    # ../../home/waybar.nix
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh.enable = true;

  programs.git = {
    userName = "Factoryidiot";
    userEmail = "rhys.scandlyn@gmail.com";
  };

  programs.kitty = {
    enable = true;
    # background_opacity = "0.96";
    font = {
      name = "JetBrainsMono";
    };
    # theme = "nord";
  };

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
          IdentityFile ~/.ssh/whio
          # Specifies that ssh should only use the identity file explicitly configured above
          # required to prevent sending default identity files first.
          IdentitiesOnly yes
    '';
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
      # theme = "nord-extended/nord";
      theme = "agnoster";
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
