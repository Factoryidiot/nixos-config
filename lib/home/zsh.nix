{
  config
  , lib
  , pkgs
  , ...
}: {

  programs.zsh = {
    enable = true;

    antidote = {
      enable = true;
      plugins = [
        # Completions
        "mattmc3/ez-compinit"
        "zsh-users/zsh-completions kind:fpath path:src"
        "aloxaf/fzf-tab"

        # Prompt
        "romkatv/powerlevel10k"

        # Utilities
        "belak/zsh-utils path:utility"
        "romkatv/zsh-bench kind:path"

        #oh-my-zsh
        "getantidote/use-omz"
        "ohmyzsh/ohmyzsh path:plugins/extract"

        # Other Fish-like features
        "zdharma-continuum/fast-syntax-highlighting"  # Syntax highlighting
        "zsh-users/zsh-autosuggestions"               # Auto-suggestions
        "zsh-users/zsh-history-substring-search"      # Up/Down to search history
      ];
    };

    dotDir = ".config/zsh";

    history = {
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/.config/zsh/.zsh_history";
      size = 10000;
    };

    # Zsh Initialisation Content
    initContent = ''
      if [ "$TERM" = "linux" ]; then
        fastfetch
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
      fi
      [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh;
    '';

  };

  home.file = {
    ".config/zsh/.p10k.zsh" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zsh/.p10k.zsh";
    };
  };

}
