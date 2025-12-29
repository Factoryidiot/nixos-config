# lib/home/github.nix
{ config, pkgs, lib, ... }:

{
  options.programs.github = {
    enable = lib.mkEnableOption "github";
  };

  config = lib.mkIf config.programs.github.enable {
    home.sessionVariables.GITHUB_TOKEN = lib.mkIf (config.age.secrets.github_token.path != null) (
      builtins.readFile config.age.secrets.github_token.path
    );
  };
}
