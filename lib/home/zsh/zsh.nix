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
  #home.file = {
    # Create the symlink for p10k.zsh
    #"./p10k.zsh" = {
    #  # The source path points to the existing file in the home directory,
    #  # but we use mkOutOfStoreSymlink to tell Nix it's external.
    #  source = ./zsh/p10k.zsh";
    #  executable = true;
    #};

    # Create the symlink for p10k-portable.zsh
    #"./p10k-portable.zsh" = {
    #  source = ./zsh/p10k-portable.zsh";
    #  executable = true;
    #};
  #};

  # 2. Zsh Program Configuration
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

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    #plugins = [
    #  {
    #    name = "powerlevel10k";
    #    src = pkgs.zsh-powerlevel10k;
    #    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #  }
    #];

    # 3. Zsh Initialisation Content
    initContent = ''
      # Source P10K from the human-managed dotfiles directory
      if [ "$TERM" = "linux" ]; then
        source ~/.dotfiles/zsh/p10k-portable.zsh
        fastfetch
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
      else
        source ~/.dotfiles/zsh/p10k.zsh
      fi
      
      # NOTE: We keep ZDOTDIR unset unless specifically needed for other configs.
    '';
  };
}
