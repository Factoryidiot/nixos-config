{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.ncdu;
in {
  options = {
    programs.ncdu = {
      enable = mkEnableOption "ncdu disk usage analyzer";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ncdu
    ];
  };
}
