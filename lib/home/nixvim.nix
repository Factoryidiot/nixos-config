# lib/home/nixvim.nix
{ lib
, config
, ... 
}: {

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
    ];

    opts = {
      #+----- general ----------------------------
      clipboard = "unnamedplus";
      mouse = "a";
      splitbelow = true;
      splitright = true;
      timeoutlen = 500;
      termguicolors = true;
      completeopt = "menuone,noselect";
      updatetime = 300;

      #+----- tab settings -----------------------
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      shiftround = true;
      autoindent = true;
      smartindent = true;

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

      #+----- swap -------------------------------
      swapfile = false;
      backup = false;
      writebackup = false;
      undofile = true;

      #+----- text -------------------------------
      list = true;
      listchars = {
        tab = "→ ";
        trail = "°";
        extends = "›";
        precedes = "‹";
      };

      #+----- folding ----------------------------
      foldmethod = "indent";
      foldlevel = 99;
      foldenable = false;
    };

    plugins = {
      lsp = {
        enable = true;
	servers = {
	  jsonls.enable = true;
	  lua_ls.enable = true;
	  nixd.enable = true;
	};
      };

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

      lazygit = {
        enable = true;
        settings = {
          floating_window_winblend = 0;
          floating_window_scaling_factor = 0.9;
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

      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "tokyonight";
            icons_enabled = true;
            section_separators = { left = ""; right = ""; };
            component_separators = { left = ""; right = ""; };
          };
        };
      };

      telescope = {
        enable = true;
        extensions."fzf-native" = {
          enable = true;          # enable fzf-native extension
          settings = {
            fuzzy = true;
            override_file_sorter = true;
            override_generic_sorter = true;
            case_mode = "smart_case";
          };
        };

        settings = {
          defaults = {
            layout_config = { prompt_position = "top"; };
            sorting_strategy = "ascending";
          };
          pickers.find_files.hidden = true;
        };
      };

      web-devicons.enable = true;
    };

    viAlias = true;
    vimAlias = true;
  };

}
