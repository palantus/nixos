{
  inputs,
  lib,
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

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
    filetree.neo-tree.enable = true;
    binds.whichKey.enable = true;
    git.gitsigns.enable = true;
    useSystemClipboard = true;
    terminal.toggleterm.lazygit.enable = true;
    ui.noice.enable = true;
    notes.todo-comments.enable = true;
    mini.basics.enable = true;
    mini.ai.enable = true;
    mini.surround.enable = true;
    mini.statusline.enable = true;

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
      # "\\" = "File tree";
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
        key = "<leader>q";
        mode = ["n"];
        action = ":q<CR>";
        silent = true;
        desc = "Quit";
      }
      {
        key = "\\";
        mode = ["n"];
        action = ":Neotree toggle<CR>";
        silent = true;
        desc = "Quit";
      }
      {
        key = "<Esc>";
        mode = ["n"];
        action = ":nohlsearch<CR>"; # Clear search highlight
        silent = true;
        # desc = "Quit";
      }
    ];
  };
}
