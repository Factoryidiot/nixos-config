# lib/home/shell.nix
{ config
, lib
, pkgs
, ...
}: {

  home.sessionPath = [
    "${config.home.homeDirectory}/.dotfiles/bin"
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    powerlevel10k.enable = true; # Enabled powerlevel10k
    syntaxHighlighting.enable = true; # Enabled via programs.zsh.antidote

    # Disabled in favor of antidote
    # autosuggestion.enable = true;
    # plugins = [
    #   { name = "zsh-history-substring-search"; src = pkgs.zsh-history-substring-search; }
    #   pkgs.zsh-completions
    #   pkgs.zsh-fzf-tab
    # ];
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "extract"
    #     "powerlevel10k/powerlevel10k"
    #   ];
    # };

    antidote = {
      enable = true;
      plugins = [
        # Completions
        "mattmc3/ez-compinit"
        "zsh-users/zsh-completions kind:fpath path:src"
        "aloxaf/fzf-tab"

        # Completion styles
        "belak/zsh-utils path:completion/functions kind:autoload post:compstyle_zshzoo_setup"

        # Keybindings
        "belak/zsh-utils path:editor"

        # History
        "belak/zsh-utils path:history"

        # Prompt
        "romkatv/powerlevel10k"

        # Utilities
        # "zshzoo/macos conditional:is-macos" # Omitted as it's macOS specific
        "belak/zsh-utils path:utility"
        "romkatv/zsh-bench kind:path"
        "ohmyzsh/ohmyzsh path:plugins/extract"

        # Other Fish-like features
        "zdharma-continuum/fast-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
      ];
    };


    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      ignoreAllDups = true;
      path = "${config.programs.zsh.dotDir}/.zsh_history";
      size = 10000;
    };

    # Zsh Initialisation Content
    initContent = ''
      if [ "$TERM" = "linux" ]; then
        fastfetch
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
      fi
      [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh;
      if [ -f "$HOME/.config/github/env.sh" ]; then
        source "$HOME/.config/github/env.sh"
      fi
    '';

    # Override antidote's staticfile path
    initExtra = ''
      staticfile="$HOME/.cache/zsh/antidote_static.zsh"
      zstyle ':antidote:static' file "$staticfile"
    '';

    shellAliases = {
      eza = "eza --icons auto --git"; # Re-aliasing eza itself for consistency
      ls = "eza --icons auto --git";
      l = "eza -alh --icons auto --git";
      ll = "eza -l --icons auto --git";
      la = "eza -a --icons auto --git";
      lt = "eza --tree --icons auto --git";
    };

  };

  xdg.configFile = {
    "zsh/.p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zsh/.p10k.zsh";
  };

}
