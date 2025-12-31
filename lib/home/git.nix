# lib/home/git.nix
{ config, pkgs, lib, ... }: {

  programs.gh = {
    enable = true;
    settings = {
      credential.helper = "libsecret";
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.git = {
    enable = true;
    ignores = [
      "*~"

    ];
    settings = {
      user.name = "Rhys Scandlyn";
      user.email = "rhys.scandlyn@gmail.com";
    };
  };

  programs.lazygit.enable = true;

  xdg.configFile = {
    ".config/github/env.sh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/github/env.sh";
  };

  # Ensure this env.sh is sourced by the shell
  programs.zsh.initContent = lib.mkIf (config.programs.zsh.enable) ''
    if [ -f "$HOME/.config/github/env.sh" ]; then
      . "$HOME/.config/github/env.sh"
    fi
  '';

}
