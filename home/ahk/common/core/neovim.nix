{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  
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

    languages = {
      enableLSP = true;
      enableTreesitter = true;
      enableFormat = true;
      
      nix.enable = true;
      ts.enable = true;
      rust.enable = true;
    };
  };
}
