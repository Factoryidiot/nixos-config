# lib/home/zsh/zsh.nix
{
  config
  , lib
  , pkgs
  , ...
}:
let

in
{

  # Zsh Program Configuration
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
        "zshzoo/macos conditional:is-macos"
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

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      ignoreAllDups = true;
    };

    # Zsh Initialisation Content
    initContent = ''
      # Source P10K from the human-managed dotfiles directory
      if [ "$TERM" = "linux" ]; then
        source ~/.dotfiles/zsh/.p10k.zsh
        fastfetch
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
      else
        source ~/.dotfiles/zsh/.p10k.zsh
      fi
 
      # NOTE: We keep ZDOTDIR unset unless specifically needed for other configs.
    '';
  };

  ".p10k.zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/sources/.p10k.zsh";
  };

}
