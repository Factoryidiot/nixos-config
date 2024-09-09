{
  pkgs,
  ...
}: {

  imports = [
    ../../home/core.nix

    ../../home/fastfetch.nix
    ../../home/git.nix
    ../../home/neovim.nix
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

  user.user.rhys.shell = pkgs.zsh;

  programs.zsh = {
    history = {
      size = 10000;
    };

    shellInit = ''
    echo ""
    if [[ $(tty) == *"pts"* ]]; then
      fastfetch
    fi
    '';

  };

}
