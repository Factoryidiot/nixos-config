# ./lib/home/eza.nix
{
  ...
}: {

  programs.eza = {
    enable = true;
    enableZshIntegration = true; # Adds keybindings and completions
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    git = true; # Add git status columns
    icons = "auto"; # Enable file-type icons
  };

}
