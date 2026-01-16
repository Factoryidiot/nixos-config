# lib/home/nixvim.nix
{ config, lib, ... }:
{

  programs.nixvim = {
    enable = true;
    colorschemes.nord.enable = true;
    defaultEditor = true;

    globals.mapleader = " ";
    
    keymaps = [
      {
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.noremap = true;
      }

      #+----- gitsigns ---------------------------
      {
        mode = "n";
        key = "<leader>lp";
        action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
        options.silent = true;
      }

      #+----- lazygit ----------------------------
      {
        mode = "n";
        key = "<leader>lg";
        action = "<cmd>LazyGit<CR>";
        options.silent = true;
      }
    ];

    opts = {
      #+----- folding ----------------------------
      foldmethod = "indent";
      foldlevel = 99;
      foldenable = false;

      #+----- general settings -------------------
      clipboard = "unnamedplus";
      mouse = "a";
      splitbelow = true;
      splitright = true;
      timeoutlen = 500;
      termguicolors = true;
      completeopt = "menuone,noselect";
      updatetime = 300;

      #+----- linenumbers ------------------------
      number = true;
      relativenumber = true;
      wrap = false;
      cursorline = true;
      signcolumn = "yes";
      scrolloff = 8;
      sidescrolloff = 5;

      #+----- search -----------------------------
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hlsearch = true;

      #+----- swap ------------------------------
      swapfile = false;
      backup = false;
      writebackup = false;
      undofile = true;

      #+----- tab settings -----------------------
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      shiftround = true;
      autoindent = true;
      smartindent = true;

      #+----- text stuff -------------------------
      list = true;
      listchars = {
        tab = "→ ";
        trail = "°";
        extends = "›";
        precedes = "‹";
      };

    };

    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          attach_to_untracked = true;
          current_line_blame = true;
          current_line_blame_opts = {
            delay = 0;
            virt_text_pos = "eol";
          };
        };
      };
      "indent-blankline" = {
        enable = true;
        settings = {
          indent = { char = "▏"; tab_char = "▏"; };
          scope = {
            enabled = true;
            show_start = true;
            show_end = false;
          };
        };
      };
      lazygit = {
        enable = true;
        settings = {
          floating_window_winblend = 0;
          floating_window_scaling_factor = 0.9;
        };
      };
      lsp = {
        enable = true;
        servers = {
	        cssls.enable   = true;
          jsonls.enable  = true;
          lua_ls.enable  = true;
          nixd.enable    = true;
        };
      };
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "nord";
            icons_enabled = true;
            section_separators = { left = ""; right = ""; };
            component_separators = { left = ""; right = ""; };
          };
        };
      };
      telescope = {
        enable = true;
        extensions."fzf-native" = {
          enable = true; 
          settings = {
            fuzzy = true;
            override_file_sorter = true;
            override_generic_sorter = true;
            case_mode = "smart_case";
          };
        };
      };
      web-devicons.enable = true;
    };

    viAlias = true;
    vimAlias = true;

  };

}
