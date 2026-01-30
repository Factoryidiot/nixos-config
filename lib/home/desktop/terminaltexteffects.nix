# lib/home/terminaltexteffects.nix
{ config
, lib
, pkgs
, inputs
, ...
}: with lib;
let
  cfg = config.terminaltexteffects;

  tte-latest = pkgs.python3Packages.buildPythonApplication {
    pname = "terminaltexteffects";
    version = "0.14.0"; # Keep this in sync with the actual version
    format = "pyproject";

    src = inputs.terminaltexteffects;

    nativeBuildInputs = with pkgs.python3Packages; [
      hatchling
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      pydantic
    ];

    doCheck = false;
  };

in
{
  options.terminaltexteffects = {
    enable = mkEnableOption "Terminal Text Effects";
    package = mkOption {
      type = types.package;
      default = tte-latest;
      description = "The package to use for Terminal Text Effects.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
