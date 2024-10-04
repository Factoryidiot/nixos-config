{
  nixvim,
  pkgs,
  ...
}: {

  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.nord.enable = true;
    opts = {
      ## Context
      # colorcolumn = '80'      # str: Show col for max line length

      number = true;            # bool: Show line numbers
      relativenumber = true;    # bool: Show relative line numbers
      scrolloff = 4;            # int: Min num lines of context
      signcolumn = "yes";       # str: Show the sign column

      ## Filetypes
      encoding = "utf8";      # str: String encoding to use
      fileencoding = "utf8";    # str: File encoding to use

      ## Theme
      # syntax = 'on';          # str: Allow syntax higlighting
      termguicolors = true;     # bool: If term supports ui colors the enable
      # colorscheme = "nord";     # str: Set the colorscheme

      ## Search
      # ignorecase = true;        # bool: Ignore case in search patterns
      # smartcase = true;         # bool: Overide ignorecase if search contains capitals
      # incsearch = true;         # bool: Use incremental search
      # hlsearch = true;          # bool: Highlight search matches

      ## Whitespace
      # expandtab = true;         # bool: Use spaces instead of tabs
      # shiftwidth = 2;           # num: Size of an indent
      # softtabstop = 2;          # num: Number of spaces tabs count for in insert mode
      # tabstop = 2;              # num: Number of spaces tab count for

      ## Splits
      # splitright = true;        # bool: Place new window to the right of the current window
      # splitbelow = true;        # bool: Place new window below the current window

      ##Set complete opt to have a better completion experience
      ## :help complete opt
      ## menuone: popup even when there's only one match
      ## noinsert: Do not insert text until a selection is made
      ## noselect: Do not select, force to select one from the menu
      ## shortness: avoid showing extra messages when using completion
      ## updatetime: set updatetime for CursorHold
      completeopt = [ "menuone" "noselect" "noinsert" ];
      # shortmess = vim.shortmess + { c = true};
    };

    plugins = {
      ## Completion
      cmp-buffer.enable = true;
      cmp-emoji.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";        
          };
          experimental.ghost_text = true;
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          sources = [
            {
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
            { name = "copilot"; }
            { name = "luasnip"; }
            { name = "nvim_lsp"; }
            { name = "nvim_lua"; }
            { name = "path"; }
          ];
        };
      };
      luasnip.enable = true;
      lualine.enable = true;
      nix.enable = true;
    };
  };

}
