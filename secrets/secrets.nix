let
  rhys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoXl6FEfhVy9TKbUbHyf1ipeiVpG4Wedw7yAxekMuK1";
  users = [ rhys ];
  whio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6Rh1ZZfh+mMI1ca/FIZSpQv/WGAKwNdvZQrHEP1w92";
  systems  = [ whio ];
in
{
  "secret01.age".publicKeys = [ users systems ];
  "secret02.age".publicKeys = users ++ systems;
}
