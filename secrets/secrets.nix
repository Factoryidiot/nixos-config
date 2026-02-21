let
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJCkeOcvLsmdbtI/gkuqGSB5XQYLaLdF74M3Ck2vPuQ";
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDafTPl2ibZo0aS1sdmCtOuM2Za3ZNy+BBPC015YX8ov";
in
{
  "github.age".publicKeys = [ user host ];
  "git-config.age".publicKeys = [ user host ];
}
