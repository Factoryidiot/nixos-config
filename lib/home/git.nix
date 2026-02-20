# lib/home/git.nix
{ config
, lib
, pkgs
, ...
}: {

  programs.gh = {
    enable = true;
    settings = {
      credential.helper = "libsecret";
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.git = {
    enable = true;
    includes = [
      { path = "/run/agenix/git-config"; }
    ];
  };    

  programs.lazygit.enable = false;

}
