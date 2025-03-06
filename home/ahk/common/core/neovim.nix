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
    telescope.enable = true;
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
      ts.enable = true;
      rust.enable = true;
      css.enable = true;
      html.enable = true;
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
        mode = ["n"];
        action = ":wq<CR>";
        silent = true;
        desc = "Save file and quit";
      }
      {
        key = "<leader>ww";
        mode = ["n"];
        action = ":w<CR>";
        silent = true;
        desc = "Save file";
      }
      {
        key = "<leader>q";
        mode = ["n"];
        action = ":q<CR>";
        silent = true;
        desc = "Quit";
      }
      {
        key = "<leader>tf";
        mode = ["n"];
        action = ":Neotree reveal<CR>";
        silent = true;
        desc = "Neotree reveal";
      }
      {
        key = "<leader>tt";
        mode = ["n"];
        action = ":Neotree toggle<CR>";
        silent = true;
        desc = "Neotree toggle";
      }
      {
        key = "<Esc>";
        mode = ["n"];
        action = ":nohlsearch<CR>"; # Clear search highlight
        silent = true;
        # desc = "Quit";
      }
      {
        key = "<C-h>";
        mode = ["n"];
        action = "<C-w><C-h>"; # Move focus to window to the left
        silent = true;
      }
      {
        key = "<C-l>";
        mode = ["n"];
        action = "<C-w><C-l>"; # Move focus to window to the right
        silent = true;
      }
      {
        key = "<C-j>";
        mode = ["n"];
        action = "<C-w><C-j>"; # Move focus to window down
        silent = true;
      }
      {
        key = "<C-k>";
        mode = ["n"];
        action = "<C-w><C-k>"; # Move focus to window up
        silent = true;
      }
      {
        key = "<leader><leader>";
        mode = ["n"];
        action = ":Telescope buffers<CR>"; # Show buffers
        silent = true;
      }
    ];
  };
}
