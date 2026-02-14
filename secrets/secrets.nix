let
  rhys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJCkeOcvLsmdbtI/gkuqGSB5XQYLaLdF74M3Ck2vPuQ";
in
{
  "github.age".publicKeys = [ rhys ];
  "git-email.age".publicKeys = [ rhys ];
  "git-user-name.age".publicKeys = [ rhys ];
}
