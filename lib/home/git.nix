# lib/home/git.nix
{ ... }: {

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      #init.defaultBranch = "main";
      user.name = "Rhys Scandlyn";
      user.email = "rhys.scandlyn@gmail.com";
    };
    url = {
      "ssh://git@github.com/Factoryidiot" = { insteadOf = "https://github.com/Factoryidiot" };
    };
  };

  programs.lazygit.enable = true;

}
