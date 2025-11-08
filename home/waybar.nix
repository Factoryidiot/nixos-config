{
  pkgs,
  ...
}: {

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [];
        "clock" = {
          format = "{:%b %d %R}";
        };
      };
    };
    style = ''
      #clock {
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 0px 0px 0px 0px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
      }
    '';
  };

}
