{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      lazygit
      zig
      unzip
      nodejs
      rustc
      cargo
      # fzf
      ripgrep
      ;
  };

  programs.nvf = {
    enable = true;
  };

  programs.nvf.settings.vim = {
    viAlias = true;
    vimAlias = true;

    options = {
      tabstop = 2;
      shiftwidth = 2;
    };

    theme = {
      enable = true;
      name = lib.mkForce "tokyonight";
      style = "night";
    };

    statusline.lualine.enable = true;
    telescope = {
      enable = true;
      setupOpts = {
        pickers = {
          buffers = {
            sort_lastused = true;
            theme = "dropdown";
            previewer = false;
          };
        };
      };
    };
    autocomplete.nvim-cmp.enable = true;
    filetree.neo-tree = {
      enable = true;
      setupOpts = {
        enable_opened_markers = false;
      };
    };
    binds.whichKey.enable = true;
    git.gitsigns.enable = true;
    # useSystemClipboard = true;
    clipboard.enable = true;
    terminal.toggleterm.enable = true;
    terminal.toggleterm.lazygit.enable = true;
    ui.noice.enable = true;
    notes.todo-comments.enable = true;
    mini.basics.enable = true;
    mini.ai.enable = true;
    mini.surround.enable = true;
    mini.statusline.enable = true;
    # mini.indentscope.enable = true; # Has annoying animations
    treesitter.context.enable = true;
    treesitter.fold = true;

    lsp.enable = true;

    languages = {
      # enableLSP = true;
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      nix.format = {
        enable = true;
        type = "nixfmt";
      };
      nix.lsp.enable = true;
      ts.enable = true;
      rust.enable = true;
      css.enable = true;
      html.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; {
      avante-nvim = {
        package = avante-nvim;
        setup = "require('avante').setup{}";
      };
      aerial = {
        package = aerial-nvim;
        setup = "require('aerial').setup {}";
      };
      harpoon2 = {
        package = harpoon2;
        setup = "require('harpoon').setup {}";
        after = [ "aerial" ]; # place harpoon configuration after aerial
      };
      vim-tmux-navigator = {
        package = vim-tmux-navigator;
        # setup = "require('vim-tmux-navigator').setup {}";
      };
    };

    binds.whichKey.register = {
      "<leader>f" = "Find";
      "<leader>h" = "GitSigns";
      "<leader>g" = "Git";
      "<leader>l" = "LSP actions";
      "<leader>t" = "Toggle";
      "<leader>a" = "Avante";
      "<leader>o" = "Harpoon";
    };

    keymaps = [
      # Harpoon keymaps
      {
        key = "<leader>oa";
        mode = [ "n" ];
        action = "function() require('harpoon'):list():append() end";
        lua = true;
        silent = true;
        desc = "Harpoon add file";
      }
      {
        key = "<leader>ol";
        mode = [ "n" ];
        action = "function() local harpoon = require('harpoon') harpoon.ui:toggle_quick_menu(harpoon:list()) end";
        lua = true;
        silent = true;
        desc = "Harpoon list";
      }
      {
        key = "<leader>o1";
        mode = [ "n" ];
        action = "function() require('harpoon'):list():select(1) end";
        lua = true;
        silent = true;
        desc = "Harpoon file 1";
      }
      {
        key = "<leader>o2";
        mode = [ "n" ];
        action = "function() require('harpoon'):list():select(2) end";
        lua = true;
        silent = true;
        desc = "Harpoon file 2";
      }
      {
        key = "<leader>o3";
        mode = [ "n" ];
        action = "function() require('harpoon'):list():select(3) end";
        lua = true;
        silent = true;
        desc = "Harpoon file 3";
      }
      {
        key = "<leader>o4";
        mode = [ "n" ];
        action = "function() require('harpoon'):list():select(4) end";
        lua = true;
        silent = true;
        desc = "Harpoon file 4";
      }
      {
        key = "<leader>op";
        mode = [ "n" ];
        action = "function() require('harpoon'):list():prev() end";
        lua = true;
        silent = true;
        desc = "Harpoon prev file";
      }
      {
        key = "<leader>on";
        mode = [ "n" ];
        action = "function() require('harpoon'):list():next() end";
        lua = true;
        silent = true;
        desc = "Harpoon next file";
      }
      {
        key = "<leader>wq";
        mode = [ "n" ];
        action = ":wq<CR>";
        silent = true;
        desc = "Save file and quit";
      }
      {
        key = "<leader>ww";
        mode = [ "n" ];
        action = ":w<CR>";
        silent = true;
        desc = "Save file";
      }
      {
        key = "<leader>q";
        mode = [ "n" ];
        action = ":q<CR>";
        silent = true;
        desc = "Quit";
      }
      {
        key = "<leader>tf";
        mode = [ "n" ];
        action = ":Neotree reveal<CR>";
        silent = true;
        desc = "Neotree reveal";
      }
      {
        key = "<leader>tt";
        mode = [ "n" ];
        action = ":Neotree toggle<CR>";
        silent = true;
        desc = "Neotree toggle";
      }
      {
        key = "<Esc>";
        mode = [ "n" ];
        action = ":nohlsearch<CR>"; # Clear search highlight
        silent = true;
        # desc = "Quit";
      }
      # {
      #   key = "<C-h>";
      #   mode = [ "n" ];
      #   action = ":wincmd h<CR>"; # Move focus to window to the left
      #   silent = true;
      # }
      # {
      #   key = "<C-l>";
      #   mode = [ "n" ];
      #   action = ":wincmd l<CR>"; # Move focus to window to the left
      #   silent = true;
      # }
      # {
      #   key = "<C-j>";
      #   mode = [ "n" ];
      #   action = ":wincmd j<CR>"; # Move focus to window to the left
      #   silent = true;
      # }
      # {
      #   key = "<C-k>";
      #   mode = [ "n" ];
      #   action = ":wincmd k<CR>"; # Move focus to window to the left
      #   silent = true;
      # }
      {
        key = "<C-h>";
        mode = [ "n" ];
        action = ":TmuxNavigateLeft<CR>"; # Move focus to window to the left
        silent = true;
      }
      {
        key = "<C-l>";
        mode = [ "n" ];
        action = ":TmuxNavigateRight<CR>"; # Move focus to window to the left
        silent = true;
      }
      {
        key = "<C-j>";
        mode = [ "n" ];
        action = ":TmuxNavigateDown<CR>"; # Move focus to window to the left
        silent = true;
      }
      {
        key = "<C-k>";
        mode = [ "n" ];
        action = ":TmuxNavigateUp<CR>"; # Move focus to window to the left
        silent = true;
      }
      {
        key = "<leader><leader>";
        mode = [ "n" ];
        action = ":Telescope buffers<CR>"; # Show buffers
        silent = true;
      }
      {
        key = "<C-d>";
        mode = [ "n" ];
        action = "<C-d>zz"; # reset view
        silent = true;
      }
      {
        key = "<C-u>";
        mode = [ "n" ];
        action = "<C-u>zz"; # reset view
        silent = true;
      }
      {
        key = "n";
        mode = [ "n" ];
        action = "nzzzv"; # reset view
        silent = true;
      }
      {
        key = "N";
        mode = [ "n" ];
        action = "Nzzzv"; # reset view
        silent = true;
      }

      # vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
      # vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
      #
      # -- Reset currenl line to the middle of the screen when scrolling
      # vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true })
      # vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true })
    ];
  };
}
