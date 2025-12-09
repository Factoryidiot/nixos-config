{ config, pkgs, lib, ... }: {

  # Ensure gh is installed
  home.packages = with pkgs; [
    gh
  ];

  # Configure git to use gh's credential helper
  programs.git = {
    enable = true;
    extraConfig = {
      "credential.helper" = "gh";
    };
    userName = "Rhys Scandlyn";
    userEmail = "rhys.scandlyn@gmail.com";
  };

  # Link the gh hosts file from agenix, which contains the auth token.
  # This makes gh and git authentication work automatically.
  home.file.".config/gh/hosts.yml".source = config.age.secrets."gh-hosts.yml".path;
}
