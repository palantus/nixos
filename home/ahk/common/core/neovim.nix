{
  inputs,
  pkgs,
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
      fzf
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
      name = "tokyonight";
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
    useSystemClipboard = true;
    terminal.toggleterm.enable = true;
    terminal.toggleterm.lazygit.enable = true;
    ui.noice.enable = true;
    notes.todo-comments.enable = true;
    mini.basics.enable = true;
    mini.ai.enable = true;
    mini.surround.enable = true;
    mini.statusline.enable = true;
    # mini.indentscope.enable = true; # Has annoying animations

    languages = {
      enableLSP = true;
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
    };

    keymaps = [
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
    ];
  };
}
