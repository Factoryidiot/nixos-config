let
  #+----- User -----------------------------------
  factory = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJCkeOcvLsmdbtI/gkuqGSB5XQYLaLdF74M3Ck2vPuQ";

  #+----- Device ---------------------------------
  whio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtXE792p3Vt7LGUOUmSsXwga73dGH3XoktIIqLAHInA";
  tahi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTfwNC4TVbIAaytdW7yFsmPcYMLPzcqy3QbwCSqg/48";

  allKeys = [ factory whio tahi ];
in
{
  "github.age".publicKeys = allKeys;
  "git-config.age".publicKeys = allKeys;
}
