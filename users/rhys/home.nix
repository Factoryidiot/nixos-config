{
  pkgs
  , ...
}: {

  imports = [
    ../../home/core.nix

    ../../home/fastfetch.nix
    ../../home/zsh.nix

    ../../home/hyprland.nix

    ## Programs
    ../../programs/gh.nix
    ../../programs/git.nix
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
    };
    settings = {
      background_opacity = "0.90";
      tab_bar_edge = "top";
    };
    themeFile = "Nord";
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
    extraConfig = ''
      set-option -g status-position top
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
    '';
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      nord
    ];
    terminal = "tmux-256color";
  };

  programs.yazi = {
    enable = true;
  };

}
