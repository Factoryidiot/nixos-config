{
  config
  , lib
  , pkgs
  , ...
}: {

  programs.zsh = {
    enable = true;

    autosuggestion.enable = lib.mkForce false;
    enableCompletion = lib.mkForce false;
    syntaxHighlighting.enable = lib.mkForce false;
 
    antidote = {
      enable = true;
      plugins = [
        # Completions
        "mattmc3/ez-compinit"
        "zsh-users/zsh-completions kind:fpath path:src"
        "aloxaf/fzf-tab"

        # Completion styles
        "belak/zsh-utils path:completion/functions kind:autoload post:compstyle_zshzoo_setup"

        # Prompt
        "romkatv/powerlevel10k"

        # Keybindings
        "belak/zsh-utils path:editor"

        # History
        "belak/zsh-utils path:history"

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
      useFriendlyNames = true;
    };

    dotDir = ".config/zsh";

    history = {
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/${config.programs.zsh.dotDir}/.zsh_history";
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

  xdg.configFile = {
    "zsh/.p10k.zsh" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zsh/.p10k.zsh";
    };
  };

}
