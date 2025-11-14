{
  config
  , lib
  , pkgs
  , specialArgs
  , ...
}:
  let
  inherit (specialArgs) username;
in
 {

  environment.systemPackages = with pkgs; [
    fastfetch
  ];

}
