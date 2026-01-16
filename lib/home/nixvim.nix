# lib/home/nixvim.nix
{ lib, config, ... }: {
  options.modules.nixvim = {
    enable = lib.mkEnableOption "Nix-managed Neovim configuration";
  };

  config = lib.mkIf config.modules.nixvim.enable {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      # Enable plugins
      plugins = {
        # Add your plugins here
      };

      # Keybindings
      keymaps = [
        {
          key = "<leader>w";
          action = "<cmd>w<cr>";
          options.noremap = true;
        }
      ];

      # Options
      opts = {
        number = true;
        relativenumber = true;
      };
    };
  };
}
