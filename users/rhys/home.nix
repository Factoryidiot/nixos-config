{
  pkgs,
  ...
}: {

  imports = [

    ../../home/core.nix

    ../../home/fastfetch.nix
    ../../home/gaming.nix
    ../../home/neovim.nix
    ../../home/zsh.nix

    ../../home/hyprland.nix
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.git = {
    enable = true;
    userName = "Factoryidiot";
    userEmail = "rhys.scandlyn@gmail.com";
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
    theme = "Nord";
  };

  programs.nixvim = {
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

