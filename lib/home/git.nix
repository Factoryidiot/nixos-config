# lib/home/git.nix
{
 ...
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
    settings = {
      url."git@github.com:".insteadOf = [
        "https://github.com/"
      ];
    };

  };

  programs.lazygit.enable = false;

}
