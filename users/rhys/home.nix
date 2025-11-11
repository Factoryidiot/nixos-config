{
  pkgs
  , ...
}: {

  imports = [
    ../../home/default.nix

    ../../home/fastfetch/fastfetch.nix
    ../../home/hyprland/hyprland.nix
    ../../home/waybar/waybar.nix
    ../../home/zsh.nix

    ## Programs
    ../../programs/gh.nix
    ../../programs/git.nix
  ];

  programs.alacritty = {
    enable = true;
  };

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

  programs.yazi = {
    enable = true;
  };

}
