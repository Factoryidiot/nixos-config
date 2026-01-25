{ agenix, inputs, ... }: {

  imports = [
    agenix.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim

    ../../lib/home/btop.nix
    ../../lib/home/desktop.nix
    ../../lib/home/development.nix
    ../../lib/home/git.nix
    ../../lib/home/gtk.nix
    ../../lib/home/shell.nix
    ../../lib/home/tmux.nix
    ../../lib/home/nixvim.nix
    ../../lib/home/yazi.nix
    ../../lib/home/desktop/terminaltexteffects.nix
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

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };

  terminaltexteffects.enable = true;
}
