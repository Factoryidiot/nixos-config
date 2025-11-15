# ./modules/home/zsh.nix (or integrated into cli.nix)
{
  config
  , lib
  , pkgs
  , ... 
}:
let
  # Define the path to where your dotfiles will live on the target system
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles/zsh";

  # Define the path where the source config files live in your flake repository
  # Assuming zsh-files directory is parallel to this module file.
  sourceFilesDir = ./zsh-files;

in
{
  # 1. Symlink Configuration Files to ~/.dotfiles/zsh
  # We use home.file with an explicit target to place them in your custom directory.
  home.file = {
    # Symlink p10k.zsh into the custom dotfiles directory
    "${dotfilesDir}/p10k.zsh" = {
      source = "${sourceFilesDir}/p10k.zsh";
      executable = true;
      # Ensures the target directory exists before symlinking
      # (Necessary since we are not using xdg.configFile)
      target = "${dotfilesDir}/p10k.zsh";
    };

    # Symlink p10k-portable.zsh
    "${dotfilesDir}/p10k-portable.zsh" = {
      source = "${sourceFilesDir}/p10k-portable.zsh";
      executable = true;
      target = "${dotfilesDir}/p10k-portable.zsh";
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
      # Source P10K from the new dotfiles directory
      if [ "$TERM" = "linux" ]; then
        source ${dotfilesDir}/p10k-portable.zsh
        fastfetch
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
      else
        source ${dotfilesDir}/p10k.zsh
      fi

      # To ensure Zsh knows where to find the source files
      export ZDOTDIR="$HOME/.config/zsh" 
      # You may not need this line depending on your other Zsh configuration
    '';
  };
}
