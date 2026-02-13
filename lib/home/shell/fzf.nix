{ pkgs
, ...
}: {

  programs.fzf = {
    enable = true;

    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    defaultOptions = [
      "--preview '${pkgs.bat}/bin/bat --style=numbers --line-range :500 {}'"
    ];

    enableZshIntegration = true; # Adds keybindings and completions
    tmux.enableShellIntegration = true;
  };

}
