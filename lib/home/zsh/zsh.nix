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
  # 1. Symlink Configuration Files
  # We use mkOutOfStoreSymlink to point Nix's configuration target to a 
  # location that Nix *does not* manage, thus removing file management from Nix.

  # NOTE: Since Zsh sources the p10k files directly, we will symlink them
  # into the expected location *inside* the custom dotfiles directory.
  # We use home.file as xdg.configFile generally manages things in ~/.config

  home.file = {
    # Create the symlink for p10k.zsh
    "./p10k.zsh" = {
      # The source path points to the existing file in the home directory,
      # but we use mkOutOfStoreSymlink to tell Nix it's external.
      source = ./zsh/p10k.zsh";
      executable = true;
    };

    # Create the symlink for p10k-portable.zsh
    "./p10k-portable.zsh" = {
      source = ./zsh/p10k-portable.zsh";
      executable = true;
    };
  };

  # 2. Zsh Program Configuration
  programs.zsh = {
    enable = true;
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

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    # 3. Zsh Initialisation Content
    initContent = ''
      # Source P10K from the human-managed dotfiles directory
      if [ "$TERM" = "linux" ]; then
        source ~/p10k-portable.zsh
        fastfetch
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
      else
        source ~/p10k.zsh
      fi
      
      # NOTE: We keep ZDOTDIR unset unless specifically needed for other configs.
    '';
  };
}
