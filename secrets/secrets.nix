# secrets/secrets.nix
{
  age.secrets.github_token = {
    file = ./github_token.age;
    owner = "rhys";
    mode = "440";
  };
}
