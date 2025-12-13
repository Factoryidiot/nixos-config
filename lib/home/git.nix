# lib/home/git.nix
{ 
  ... 
}: {

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.git = {
    enable = true;
    ignores = [
      "*~"
      
    ];
    settings = {
      user.name = "Rhys Scandlyn";
      user.email = "rhys.scandlyn@gmail.com";
    };
  };

  programs.lazygit.enable = true;

}
