{ config, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true; # Not needed due to using initExtra, but good to have
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
      right_format = "$time$cmd_duration";
    };
  };

  # Conditional activation of Starship based on TERM environment variable
  programs.zsh.initContent = lib.mkIf (config.programs.starship.enable) (lib.mkOrder 100 ''
    if [[ "$TERM" != "linux" ]]; then
      eval "$(starship init zsh)"
    fi
  '');
}
