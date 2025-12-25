{
  ...
}: {

  imports = [
    ../../lib/home/btop.nix
    ../../lib/home/desktop.nix
    ../../lib/home/development.nix
    ../../lib/home/fastfetch.nix
    ../../lib/home/git.nix
    ../../lib/home/tmux.nix
    ../../lib/home/yazi.nix
    ../../lib/home/terminal.nix
  ];

  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.11";
 
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
