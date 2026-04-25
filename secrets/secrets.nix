let
  factory = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJCkeOcvLsmdbtI/gkuqGSB5XQYLaLdF74M3Ck2vPuQ";
  whio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtXE792p3Vt7LGUOUmSsXwga73dGH3XoktIIqLAHInA";
  tahi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILks8XDjEE0EQgQIKx+tQbn+71LMX7RD2C3jOeTYztaA";
  allKeys = [ factory whio tahi ];
in
{
  "github.age".publicKeys = allKeys;
  "git-config.age".publicKeys = allKeys;
}
