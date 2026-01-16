# lib/home/shell.nix
{ config
, lib
, pkgs
, ...
}: {

  imports = [
    ./shell/bat.nix
    ./shell/eza.nix
    ./shell/fastfetch.nix
    ./shell/fzf.nix
    ./shell/starship.nix
    ./shell/zoxide.nix
    ./shell/zsh.nix
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.dotfiles/bin"
  ];

  home.packages = with pkgs; [
    #+----- Shell & CLI Tools ---------------------
    #bat # Cat clone with syntax highlighting and Git integration
    fd # Simple, fast and user-friendly alternative to `find`
    jq # Needed for many Waybar scripts
    ripgrep # Search tool
    #terminaltexteffects # Screensaver
    wget # Classic command-line file downloader
  ];

}
