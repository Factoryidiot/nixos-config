let
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJCkeOcvLsmdbtI/gkuqGSB5XQYLaLdF74M3Ck2vPuQ";
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtXE792p3Vt7LGUOUmSsXwga73dGH3XoktIIqLAHInA";
in
{
  "github.age".publicKeys = [ user host ];
  "git-config.age".publicKeys = [ user host ];
}
